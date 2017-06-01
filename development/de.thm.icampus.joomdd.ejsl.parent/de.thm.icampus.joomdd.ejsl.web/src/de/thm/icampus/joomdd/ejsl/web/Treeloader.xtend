package de.thm.icampus.joomdd.ejsl.web

import com.google.gson.Gson
import com.google.inject.Inject
import java.io.File
import java.io.IOException
import javax.servlet.ServletException
import javax.servlet.annotation.WebServlet
import javax.servlet.http.HttpServlet
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse
import org.eclipse.xtext.resource.IResourceServiceProvider
import org.eclipse.emf.common.util.BasicEList
import org.eclipse.emf.common.util.EList

@WebServlet(name = 'Treeloader', urlPatterns = '/tree-loader/*')
class Treeloader extends HttpServlet {
	
	
	override protected doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		var resourcesProvider = IResourceServiceProvider.Registry.INSTANCE
		var String name = req.getParameter("name") as String
		req.session
		resp.status = HttpServletResponse.SC_OK
		resp.setHeader('Cache-Control', 'no-cache')
		
		resp.contentType = 'text/x-json'
		val gson = new Gson
		if(name !=null ){
		var String fullPath = resourcesProvider.contentTypeToFactoryMap.get("serverpath") as String + "/" + name;
		
	    var File temp = new File(fullPath)
		if(temp.exists && req.getSession().getAttribute("joomddusername") == name){
			var Treeitem workspace = new Treeitem(req.getSession(), "download-manager/")
			workspace.text = "My Workspace"
			workspace.setState("opened", true)
			var EList <Treeitem> result = new BasicEList<Treeitem>
			result.add(workspace)
		gson.toJson(result, resp.writer)
		}else{
			gson.toJson(false, resp.writer)
		}	
		}else{
			gson.toJson("Username doesn't exist" + name, resp.writer)
		}
	}
	
	override protected doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
	
	  
	}
	

}