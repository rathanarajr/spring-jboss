package com.jboss.spring;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class MyController {
	
	
	@RequestMapping("/hello")
	public String sayHello() {
		
		return "Hello LMA AR Stakeholder, Containerized version of Sample Application is running on JBOSS EAP 7.4. Please load other applications binary/archive on LIBO to containerize other applications";
		
	}

	
	
}
