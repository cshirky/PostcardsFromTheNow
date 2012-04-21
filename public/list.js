$(function() {
	
    // Set up variables
    var $el, $parentWrap, $otherWrap, 
        $allTitles = $("dt").css({
            padding: 5, // setting the padding here prevents a weird situation, where it would start animating at 0 padding instead of 5
            "cursor": "pointer" // make it seem clickable
        }),
        $allCells = $("dd").css({
            position: "relative",
            top: -1,
            left: 0,
            display: "none" // info cells are just kicked off the page with CSS (for accessibility)
        });
    
    // clicking image of inactive column just opens column, doesn't go to link   
    $("#post_column").delegate("a.image","click", function(e) { 
        
        if ( !$(this).parent().hasClass("curCol") ) {         
            e.preventDefault(); 
            $(this).next().find('dt:first').click(); 
        } 
        
    });
    
    // clicking on titles does stuff
    $("#post_column").delegate("dt", "click", function() {
        
        // cache this, as always, is good form
        $el = $(this);
				console.log($el);
        
        // if this is already the active cell, don't do anything
        if (!$el.hasClass("current")) {
        
            $parentWrap = $el.parent().parent();
            $otherWraps = $(".info-col").not($parentWrap);
            
            // remove current cell from selection of all cells
            $allTitles = $("dt").not(this);
            
            // close all info cells
            $allCells.slideUp();
            
            // return all titles (except current one) to normal size
            $allTitles.animate({
                fontSize: "16px",
                paddingTop: 5,
                paddingRight: 5,
                paddingBottom: 5,
                paddingLeft: 5
            });
            
            // animate current title to larger size            
            $el.animate({
                "font-size": "20px",
                paddingTop: 10,
                paddingRight: 0,
                paddingBottom: 0,
                paddingLeft: 10
            }).next().slideDown();
            
/*
            // make the current column the large size
            $parentWrap.animate({
                width: 60
            }).addClass("curCol");
*/
            
        }
        
    });
    
    $("#starter").trigger("click");
    
});