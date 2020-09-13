var Action = function() {}

Action.prototype = {
    
run: function(parameters) { //called before extension run
    parameters.completionFunction({"URL": document.URL, "title": document.title}); //give data dictionary with keys URL and title to extension.
},
    
finalize: function(parameters) {    //called after extension is run
    var customJavaScript = parameters["customJavaScript"];
    eval(customJavaScript);
}
    
};

var ExtensionPreprocessingJS = new Action
