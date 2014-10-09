<%@ include file="header.jsp"%>

<%@ page import="java.util.regex.*"%>
<%@ page import="org.apache.commons.codec.binary.Base64"%>

<div class="container">

<%

	if (request.getParameterMap().isEmpty()) {
		response.sendRedirect("step1.jsp");
	}

	//
	// The user is now attempting to joing the meeting
	//
	String encodedMeetingID = request.getParameter("meetingID");
	String username = request.getParameter("username1");
	
	// Get bytes from string
	byte[] byteArray = Base64.decodeBase64(encodedMeetingID.getBytes());
	
	// Print the decoded string
	String meetingID = new String(byteArray);
	
	String url = BigBlueButtonURL.replace("bigbluebutton/","meeting/");
	String enterURL = url + "step5.jsp?action=join&username=" + URLEncoder.encode(username, "UTF-8") + "&meetingID=" + URLEncoder.encode(meetingID, "UTF-8");

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
		<h2 class="form-signin-heading">Reuni�o '<%=meetingID%>' ainda n�o foi iniciada!</h2>
	</div>
</div>

<br />

<div class="page-header">

	<p class="lead">Ol� <%=username%>,</p>
	
	<p class="lead">Aguardando o moderador para come�ar a reuni�o <strong>'<%=meetingID%>'</strong>.</p>
	
	<br />
	
	<p class="lead">(Seu navegador ser� atualizado automaticamente e voc� se juntar� a reuni�o.)</p>
	
	
</div>

<%
	}
%>

<%@ include file="footer.jsp"%>