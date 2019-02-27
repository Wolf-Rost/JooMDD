define('editorhandler',[ 'jquery',"jstree","ace/ace","xtext/xtext-ace","treeloader"], function(jQuery,jstree,ace,xtext_ace,treeloader) {
	 var exports = {};
	 var editor = null;
	 exports.loadEditor = function(resourceID) {
		var baseUrl = window.location.pathname;
		var fileIndex = baseUrl.indexOf("editor.html");
	    if (fileIndex > 0) {
	    	baseUrl = baseUrl.slice(0, fileIndex);
	    }
	    
	    if (editor != null) {
			editor.destroy();
		}

		editor = xtext_ace.createEditor({
			baseUrl: baseUrl ,
			syntaxDefinition: "js/folding-mode-eJSL",
			theme: "ace/theme/clouds",
			resourceId: "/src/" + resourceID,
			dirtyElement: "dirty",
			dirtyStatusClass: "visible"
		});
				
		$("#modelname").text(resourceID)
		editor.setOptions({
			fontSize: "14px",
			minLines: 25
        });
		
		editor.xtextServices.errorListeners.push((serviceType, severity, message, requestData) => {
			if (typeof(requestData) !== 'undefined') {
				console.log(requestData.responseText);
			}
			else
			{
				console.log("Could not get the response text.");
			}
		});
                 
        // Override the generate function to include custom request parameters.
        var originInitServerData = editor.xtextServices.generatorService._initServerData;
        editor.xtextServices.generatorService._initServerData = function(serverData, editorContext, params) {
																	if (params.platform)
																	{
																		serverData.platform = params.platform;
																	}
																	originInitServerData(serverData, editorContext, params);
																} 
         
        var afterEditorCreation = function() {
        	var jstree = $('#folder_tree').jstree(true);
        	 
        	if(jstree) {
        		treeloader.reload();
        	}
        	else
        	{
        		treeloader.writeTree();
        	}
			editor.xtextServices.successListeners = editor.xtextServices.successListeners.filter(function(obj) {
				return obj.name !== "afterEditorCreation";
			});
		};
		
		editor.xtextServices.successListeners.push(afterEditorCreation);
		
		editor.on('change', function() {
	        if (editor.session.$modified) {
	        	window.onbeforeunload = function() { return "You have unsaved changes"; };
	        }
	    });
		
        return editor;
	 };
	 
	 return exports;
})
