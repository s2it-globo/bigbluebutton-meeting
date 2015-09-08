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
	String meetingName = request.getParameter("meetingName");
	String meetingId = request.getParameter("meetingID");
	String viewType = request.getParameter("viewType");
	//String authToken = request.getParameter("authToken");
	
	String joinUrlFlash = getJoinURLViewer(username, meetingId);
	String joinURL = getJoinURLViewerHtml5(username, meetingId);
	Document doc = parseXml(getURL(joinURL));

	String meetingId2 = doc.getElementsByTagName("meeting_id").item(0).getTextContent();
	String userId = doc.getElementsByTagName("user_id").item(0).getTextContent();
	String authToken = doc.getElementsByTagName("auth_token").item(0).getTextContent();
	String ip = BigBlueButtonURL.split("\\/bigbluebutton")[0];
	String html5url = ip + "/html5client/" + meetingId2 + "/" + userId + "/" + authToken;
	
	String url_to_redirect = html5url;
	
	if(viewType.equals("flash")){
		url_to_redirect = joinUrlFlash ;
   }
		
	if (joinURL.startsWith("http://") || joinURL.startsWith("https://")) {
%>

<script language="javascript" type="text/javascript">
  window.location.href="<%=url_to_redirect%>";
</script>

<%
	} 
	else { 
%>

Error: getJoinURL() failed

<p /><%=url_to_redirect%> 

<%
 	}
 %> 

<%@ include file="footer.jsp"%>