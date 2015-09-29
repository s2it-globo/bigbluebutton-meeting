<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<% 
	request.setCharacterEncoding("UTF-8"); 
	response.setCharacterEncoding("UTF-8"); 
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
	<title>Globo.com - Meeting</title>
	
	<!-- Script JS -->
	<script type="text/javascript" src="js/jquery.min.js"></script>
	<script type="text/javascript" src="js/jquery.validate.js"></script>
	<script type="text/javascript" src="js/jquery.validate.min.js"></script>
	<script type="text/javascript" src="js/jquery.validate.custom.js"></script>
	<script type="text/javascript" src="js/heartbeat.js"></script>
	<script type="text/javascript" src="js/bootstrap.min.js"></script>
	<!-- /Script JS -->
	
	<!-- CSS -->
	<link rel="icon" href="images/favicon.png" type="image/x-icon" />
	<link rel="shortcut icon" href="images/favicon.png" type="image/x-icon" /> 
	<link rel="stylesheet" type="text/css" href="css/bootstrap.min.css" media="screen" />
	<link rel="stylesheet" type="text/css" href="css/meeting.css" media="screen" />
	<!-- /CSS -->
</head>
<body>


<img src="images/globo_01.png" />

<%@ include file="bbb_api.jsp"%>