<%@ include file="header.jsp"%>

<%@ page import="java.util.regex.*"%>
<%@ page import="javax.naming.Context"%>
<%@ page import="javax.naming.directory.*"%>
<%@ page import="java.util.Hashtable"%>

<%@ page import="org.apache.commons.codec.binary.Base64"%>
<%@ page import="org.apache.commons.lang.StringEscapeUtils"%>

<div class="container">

<%

	if (request.getParameterMap().isEmpty()) {
		response.sendRedirect("step1.jsp");
	}

	//
	// We have an invite to an active meeting. Ask the person for their name 
	// so they can join.
	//

	String meetingID = request.getParameter("meetingID");
	String meetingName = request.getParameter("meetingName");
	String userId = request.getParameter("userId");
	String authToken = request.getParameter("authToken");

%>

<h2 class="form-signin-heading">Você foi convidado para participar da reunião '<%=StringEscapeUtils.escapeHtml(meetingName)%>'</h2>

<br />

<form id="form3" name="form3" action="step4.jsp" method="post" class="form-horizontal">

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
		
		<input type="hidden" name="meetingID" value="<%=meetingID%>">
		<input type="hidden" name="meetingName" value="<%=meetingName%>">
		<input type="hidden" name="userId" value="<%=userId%>">
		<input type="hidden" name="authToken" value="<%=authToken%>">
		
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
                }
            }
        });
    });
</script>

<%@ include file="footer.jsp"%>