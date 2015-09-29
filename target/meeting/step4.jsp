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
	String userId = request.getParameter("userId");
	String authToken = request.getParameter("authToken");
	String username = request.getParameter("username1");
	
	String url = BigBlueButtonURL.replace("bigbluebutton/","meeting/");
	String encodedUserName = URLEncoder.encode(username, "UTF-8");

	String urlParameters = String.format("step5.jsp?action=join&username=%s&meetingID=%s&authToken=%s", encodedUserName, mettingName, authToken);

	String enterURL = url + urlParameters;

	String joinURL = getJoinURLHTML5(username, mettingName, "false", null, null, null);

	//Extract data from the xml
	String meetingId = doc.getElementsByTagName("meeting_id").item(0).getTextContent();
	String userId = doc.getElementsByTagName("user_id").item(0).getTextContent();
	String ip = BigBlueButtonURL.split("\\/bigbluebutton")[0];

	// redirect towards the html5 client which is waiting for the following parameters
	String html5url = ip + "/html5client/" + meetingId + "/" + userId + "/" + authToken;


	if (isMeetingRunning(mettingName).equals("true")) {
		//
		// The meeting has started -- bring the user into the meeting.
		//
		%>

		<script type="text/javascript">
			window.location = "<%=html5url%>";
		</script>

		<%
	} else {
			//
			// The meeting has not yet started, so check until we get back the status that the meeting is running
			//
			String checkMeetingStatus = getURLisMeetingRunning(mettingName);

%>

<script type="text/javascript">

$(document).ready(function(){
		$.jheartbeat.set({
		   url: "<%=checkMeetingStatus%>",
		   delay: 300
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
		<h2 class="form-signin-heading">Reuni�o '<%=StringEscapeUtils.escapeHtml(mettingName)%>' ainda n�o foi iniciada!</h2>
	</div>
</div>

<br />

<div class="page-header">

	<p class="lead">Ol� <%=StringEscapeUtils.escapeHtml(username)%>,</p>
	
	<p class="lead">Aguardando o moderador para come�ar a reuni�o <strong>'<%=StringEscapeUtils.escapeHtml(mettingName)%>'</strong>.</p>
	
	<br />
	
	<p class="lead">(Seu navegador ser� atualizado automaticamente e voc� se juntar� a reuni�o.)</p>
	
	
</div>

<%
	}
%>

<%@ include file="footer.jsp"%>