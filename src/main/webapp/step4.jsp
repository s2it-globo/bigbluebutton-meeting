<%@ include file="header.jsp"%>

<%@ page import="java.util.regex.*"%>
<%@ page import="org.apache.commons.codec.binary.Base64"%>
<%@ page import="org.apache.commons.lang.StringEscapeUtils"%>

<div class="container">

<%

	if (request.getParameterMap().isEmpty()) {
		response.sendRedirect("step1.jsp");
	}

	//
	// The user is now attempting to joing the meeting
	//
	String meetingID = request.getParameter("meetingID");
	String mettingName = request.getParameter("meetingName");
	String username = request.getParameter("username1");
	
	String url = BigBlueButtonURL.replace("bigbluebutton/","meeting/");
	String encodedUserName = URLEncoder.encode(username, "UTF-8");
	String urlParameters = String.format("step5.jsp?action=join&username=%s&meetingID=%s", encodedUserName, meetingID);
	
	String enterURL = url + urlParameters;

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
		<h2 class="form-signin-heading">Reunião '<%=StringEscapeUtils.escapeHtml(mettingName)%>' ainda não foi iniciada!</h2>
	</div>
</div>

<br />

<div class="page-header">

	<p class="lead">Olá <%=StringEscapeUtils.escapeHtml(username)%>,</p>
	
	<p class="lead">Aguardando o moderador para começar a reunião <strong>'<%=StringEscapeUtils.escapeHtml(mettingName)%>'</strong>.</p>
	
	<br />
	
	<p class="lead">(Seu navegador será atualizado automaticamente e você se juntará a reunião.)</p>
	
	
</div>

<%
	}
%>

<%@ include file="footer.jsp"%>