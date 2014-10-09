<%@ include file="header.jsp"%>

<%@ page import="java.util.regex.*"%>

<%@ page import="javax.naming.Context"%>
<%@ page import="javax.naming.directory.*"%>
<%@ page import="java.util.Hashtable"%>

<div class="container">

<h2 class="form-signin-heading">Crie sua própria reunião</h2>

<br />

<%
	if(!request.getParameterMap().isEmpty() && request.getParameterMap().containsKey("auth")) {
		if(request.getParameter("auth").equals("false")) {
%>

<div class="alert alert-error">
	Usuário e/ou senha inválido.
</div>

<%
		}
	}
%>

<form id="form1" name="form1" action="step2.jsp" method="post" class="form-horizontal">

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

<%@ include file="footer.jsp"%>