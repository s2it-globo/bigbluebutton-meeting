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
	<script type="text/javascript" src="js/jquery.min.js"></script>
	<script type="text/javascript" src="js/jquery.validate.js"></script>
	<script type="text/javascript" src="js/jquery.validate.min.js"></script>
	<script type="text/javascript" src="js/jquery.validate.custom.js"></script>
	
	<script type="text/javascript" src="js/heartbeat.js"></script>
	<script type="text/javascript" src="js/bootstrap.min.js"></script>
</head>
<body>

<%@ include file="header.jsp"%>

<%@ include file="bbb_api.jsp"%>

<%@ page import="java.util.regex.*"%>

<%@ page import="javax.naming.Context"%>
<%@ page import="javax.naming.directory.*"%>
<%@ page import="java.util.Hashtable"%>

<div class="container">

<%
	if (request.getParameterMap().isEmpty()) {
		
		//
		// Assume we want to create a meeting
		//
%>

<h2 class="form-signin-heading">Crie sua própria reunião</h2>

<br />

<form id="form1" name="form1" method="post" class="form-horizontal">

	<fieldset>

		<!-- Form Name -->
		<legend>Passo 1 - Informe os dados abaixo:</legend>

		<!-- Text input-->
		<div class="control-group">
			<label class="control-label" for="meetingId">Reunião</label>
			<div class="controls">
				<input id="meetingId" name="meetingId" class="input-xlarge" type="text" autofocus required>
			</div>
		</div>

		<!-- Text input-->
		<div class="control-group">
			<label class="control-label" for="username">Usuário</label>
			<div class="controls">
				<input id="username" name="username" class="input-xlarge" type="text" autofocus required>
			</div>
		</div>

		<!-- Password input-->
		<div class="control-group">
			<label class="control-label" for="password">Senha</label>
			<div class="controls">
				<input id="password" name="password" class="input-xlarge" type="password" autofocus required>
			</div>
		</div>
		
		<input type="hidden" name="action" value="create">
		
		<!-- Button -->
		<div class="control-group">
			<label class="control-label" for="submit-button"></label>
			<div class="controls">
				<button id="submit-button" name="submit-button" class="btn btn-primary">Criar reunião</button>
			</div>
		</div>
		
	</fieldset>
	
</form>

<script type="text/javascript">
    $(document).ready(function(){
        $('#form1').validate({
            errorClass: "meeting-error-class",
            validClass: "meeting-valid-class",
            rules:{
            	meetingId:{
                	required: true
                },
                username:{
                	required: true
                },
                password:{
                	required: true
                }
            }
        });
    });
</script>

<%
	} else if (request.getParameter("action").equals("create")) {
		
		//
		// User has requested to create a meeting
		//

		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String meetingID = request.getParameter("meetingId");
		
		Hashtable<String, String> env = new Hashtable<String, String>();
		env.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.ldap.LdapCtxFactory");
		env.put(Context.PROVIDER_URL, "ldap://192.168.24.14:389/cn=ldapweb,ou=Usuarios,dc=globoi,dc=com");
		env.put(Context.SECURITY_AUTHENTICATION, "simple");
		env.put(Context.SECURITY_PRINCIPAL, "cn=" + username + ",ou=Usuarios,dc=globoi,dc=com");
		env.put(Context.SECURITY_CREDENTIALS, password);
		
		DirContext ctx = null;
		boolean auth = false;
		try {
			ctx = new InitialDirContext(env);
			auth = true;
		}
		catch (Exception e) {
			e.printStackTrace();
		} 
		finally {
			if (ctx != null) {
				try {
					ctx.close();
				} 
				catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
		
		if(!auth) {
			response.sendRedirect("index.jsp");	
		}
		
		//
		// This is the URL for to join the meeting as moderator
		//
		String joinURL = getJoinURL(username, meetingID, "false", "<br>Bem-vindo ao %%CONFNAME%%.<br>", null, null);

		String url = BigBlueButtonURL.replace("bigbluebutton/","meeting/");
		String inviteURL = url + "index.jsp?action=invite&meetingID=" + URLEncoder.encode(meetingID, "UTF-8");
%>

<h2 class="form-signin-heading">Reunião '<%=meetingID%>' foi criada com sucesso!</h2>

<br />

<div class="page-header">
	<h3>Passo 2 - Convide outras pessoas usando o seguinte link (mostrado abaixo):</h3>
	<p class="lead">
		<%=inviteURL%>
	</p>
</div>

<div class="page-header">
	<h3>Passo 3 - Clique no link abaixo para iniciar a sua reunião:</h3>
	<p class="lead">
		<a href="<%=joinURL%>">Iniciar reunião</a>
	</p>
</div>

<%
	} else if (request.getParameter("action").equals("enter")) {
		
		//
		// The user is now attempting to joing the meeting
		//
		String meetingID = request.getParameter("meetingID");
		String username = request.getParameter("username1");
		String password = request.getParameter("password1");
		
		Hashtable<String, String> env = new Hashtable<String, String>();
		env.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.ldap.LdapCtxFactory");
		env.put(Context.PROVIDER_URL, "ldap://192.168.24.14:389/cn=ldapweb,ou=Usuarios,dc=globoi,dc=com");
		env.put(Context.SECURITY_AUTHENTICATION, "simple");
		env.put(Context.SECURITY_PRINCIPAL, "cn=" + username + ",ou=Usuarios,dc=globoi,dc=com");
		env.put(Context.SECURITY_CREDENTIALS, password);
		
		DirContext ctx = null;
		boolean auth = false;
		try {
			ctx = new InitialDirContext(env);
			auth = true;
		}
		catch (Exception e) {
			e.printStackTrace();
		} 
		finally {
			if (ctx != null) {
				try {
					ctx.close();
				} 
				catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
		
		if(!auth) {
			response.sendRedirect("index.jsp?action=invite&meetingID=" + meetingID);	
		}

		String url = BigBlueButtonURL.replace("bigbluebutton/","meeting/");
		String enterURL = url + "index.jsp?action=join&username=" + URLEncoder.encode(username, "UTF-8") + "&meetingID=" + URLEncoder.encode(meetingID, "UTF-8");

		if (isMeetingRunning(meetingID).equals("true")) {
			//
			// The meeting has started -- bring the user into the meeting.
			//
%>

<script type="text/javascript">
	window.location = "<%=enterURL%>";
</script>

<%
	} else {
			//
			// The meeting has not yet started, so check until we get back the status that the meeting is running
			//
			String checkMeetingStatus = getURLisMeetingRunning(meetingID);
%>

<script type="text/javascript">

$(document).ready(function(){
		$.jheartbeat.set({
		   url: "<%=checkMeetingStatus%>",
		   delay: 5000
		}, function () {
			mycallback();
		});
	});


function mycallback() {
	// Not elegant, but works around a bug in IE8 
	var isMeetingRunning = ($("#HeartBeatDIV").text().search("true") > 0 );

	if (isMeetingRunning) {
		window.location = "<%=enterURL%>"; 
	}
}

</script>

<div class="control-group">
	<img src="images/polling.gif"></img>
	<div class="controls">
		<h2 class="form-signin-heading">Reunião '<%=meetingID%>' ainda não foi iniciada!</h2>
	</div>
</div>

<br />

<div class="page-header">

	<p class="lead">Olá <%=username%>,</p>
	
	<p class="lead">Aguardando o moderador para começar a reunião <strong>'<%=meetingID%>'</strong>.</p>
	
	<br />
	
	<p class="lead">(Seu navegador será atualizado automaticamente e você se juntará a reunião.)</p>
	
	
</div>

<%
}
	} else if (request.getParameter("action").equals("invite")) {
		//
		// We have an invite to an active meeting.  Ask the person for their name 
		// so they can join.
		//
		String meetingID = request.getParameter("meetingID");
%>

<h2 class="form-signin-heading">Você foi convidado para participar da reunião '<%=meetingID%>'</h2>

<br />

<form id="form3" name="form3" method="get" class="form-horizontal">

	<fieldset>

		<!-- Form Name -->
		<legend>Informe os dados abaixo:</legend>

		<!-- Text input-->
		<div class="control-group">
			<label class="control-label" for="username1">Usuário</label>
			<div class="controls">
				<input id="username1" name="username1" class="input-xlarge" type="text" autofocus required>
			</div>
		</div>

		<!-- Password input-->
		<div class="control-group">
			<label class="control-label" for="password1">Senha</label>
			<div class="controls">
				<input id="password1" name="password1" class="input-xlarge" type="password" autofocus required>
			</div>
		</div>
		
		<input type="hidden" name="action" value="enter">
		
		<input type="hidden" name="meetingID" value="<%=meetingID%>">
		
		<!-- Button -->
		<div class="control-group">
			<label class="control-label" for="submit-button1"></label>
			<div class="controls">
				<button id="submit-button1" name="submit-button1" class="btn btn-primary">Entrar</button>
			</div>
		</div>
		
	</fieldset>
	
</form>

<script type="text/javascript">
    $(document).ready(function(){
        $('#form3').validate({
            errorClass: "meeting-error-class",
            validClass: "meeting-valid-class",
            rules:{
                username1:{
                	required: true
                },
                password1:{
                	required: true
                }
            }
        });
    });
</script>

<%
	} else if (request.getParameter("action").equals("join")) {
		//
		// We have an invite request to join an existing meeting and the meeting is running
		//
		// We don't need to pass a meeting descritpion as it's already been set by the first time 
		// the meeting was created.
		String joinURL = getJoinURLViewer(request.getParameter("username"), request.getParameter("meetingID"));
			
		if (joinURL.startsWith("http://")) {
%>

<script language="javascript" type="text/javascript">
  window.location.href="<%=joinURL%>";
</script>

<%
	} else { 
%>

Error: getJoinURL() failed

<p /><%=joinURL%> 

<%
 	}
 }
 %> 

<%@ include file="footer.jsp"%>

</body>

</html>