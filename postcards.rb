
require 'rubygems'
require 'sinatra'
require 'dm-core'
require 'dm-timestamps'
require 'dm-migrations'
require 'carrierwave/datamapper'
require 'carrierwave'
require 'carrierwave/processing/mini_magick'
#require 'mini_magick'

require 'bundler'
Bundler.require


DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/development.db") 

 
class MyUploader < CarrierWave::Uploader::Base
 include CarrierWave::MiniMagick
	storage:fog	
   #storage :file
   
   def filename
        @name ||= "#{secure_token}.#{file.extension}" if original_filename.present?
     end
   
     protected
     def secure_token
       var = :"@#{mounted_as}_secure_token"
       model.instance_variable_get(var) or model.instance_variable_set(var,SecureRandom.base64.tr("+/", "-_"))
     end
   
   def extension_white_list
       %w(jpg jpeg gif png)
   end
    
  process :resize_to_limit =>[800,600]  
      
   version :thumb do
          process :resize_to_fill => [300,200]

   end
   
   def cache_dir
     "#{settings.root}/tmp/uploads"
   end
   
end

CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',       # required
    :aws_access_key_id      => 'AKIAIFPEBMII5R3LSUAA',       # required
    :aws_secret_access_key  => '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',       # required
    :region                 => 'us-east-1'  # optional, defaults to 'us-east-1'
  }
  config.fog_directory  = 'viewthroughthewindow'                     # required
  # config.fog_hos       = 'https://assets.example.com'            # optional, defaults to nil
  # config.fog_public     = false                                   # optional, defaults to true
  # config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
end

class Post
  include DataMapper::Resource  
  property :post_id,      Serial
  property :city,         String
  property :country,      String
  property :thoughts,     Text  
  property :created_at, DateTime
  property :user_name,	String
  property :user_email,	String 
  mount_uploader :image1, MyUploader
  mount_uploader :image2, MyUploader  
end

class Comment
  include DataMapper::Resource  
  property :comment_id,      Serial
  property :post_id, 	Integer
  property :text,         Text
  property :user_name,    String
  property :created_at, DateTime
end

DataMapper.auto_upgrade!
  
# Main page: view all posts
get '/' do
@posts = Post.all(:order => [ :post_id.desc ], :limit => 35)
  erb :index
end

# Create Post
post '/post/create' do
  post = Post.new(:thoughts => params[:thoughts])  
  post.save
  post.city = params[:city]
  post.country = params[:country]
  post.user_name = params[:user_name] 
  post.user_email = params[:user_email] 
  post.image1 = params[:pic1]  
  post.image2 = params[:pic2]
  success = post.save
    
  if success
    status 201
    redirect '/'  
  else
    status 412
    redirect '/posts'   
  end
end

# Create Comment
post '/comment/create/:post_id' do
	comment = Comment.new
	comment.post_id = params[:post_id]
	comment.user_name=params[:user_name]
	comment.text = params[:comment_text]
	comment.created_at = Time.now
	if comment.save
	  status 201
	  redirect '/'  
	else
	  status 412
	  redirect '/'   
	end
end


#Permalink

get '/:post_id' do
  @post=Post.get(params[:post_id])
  erb :post
end


