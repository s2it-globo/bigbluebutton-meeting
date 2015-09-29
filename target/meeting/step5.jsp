<%@ include file="header.jsp"%>

<%@ page import="java.util.regex.*"%>
<%@ page import="javax.naming.Context"%>
<%@ page import="javax.naming.directory.*"%>
<%@ page import="java.util.Hashtable"%>

<div class="container">


<%
	//
	// We have an invite request to join an existing meeting and the meeting is running
	//
	// We don't need to pass a meeting descritpion as it's already been set by the first time 
	// the meeting was created.
	String username = request.getParameter("username");
	String meetingID = request.getParameter("meetingID");
	String authToken = request.getParameter("authToken");
	
	//String joinURL = getJoinURLViewer(username, meetingID);

	String ip = BigBlueButtonURL.split("\\/bigbluebutton")[0];
	String html5url = ip + "/html5client/" + meetingID + "/" + username + "/" + authToken;
		
	if (ip.startsWith("http://") || ip.startsWith("https://")) {
%>

<script language="javascript" type="text/javascript">
  window.location.href="<%=html5url%>";
</script>

<%
	} else { 
%>

Error: getJoinURL() failed

<p /><%=html5url%> 

<%
 	}
 %> 

<%@ include file="footer.jsp"%>