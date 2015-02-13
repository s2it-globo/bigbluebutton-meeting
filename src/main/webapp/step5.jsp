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
	
	String joinURL = getJoinURLViewer(username, meetingID);
		
	if (joinURL.startsWith("http://") || joinURL.startsWith("https://")) {
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
 %> 

<%@ include file="footer.jsp"%>