package com.jboss.spring;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**@RestController
public class MyController {
	
	
	@RequestMapping("/hello")
	public String sayHello() {
		
	return "<html><body><h2> Hello LMA AR Stakeholder, Containerized version of Sample Application is running on JBOSS EAP 7.4.Please load other applications binary/archive to containerize other applications </h2></body></html>";
	//return "index";
	}
	
}**/
@Controller
public class HomeController {

    @RequestMapping("/")
    public String welcome() throws Exception {
        return "home.html"; //note that this says .html
    }
}

	
	
