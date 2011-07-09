<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="javax.persistence.Query" %>
<%@ page import="javax.persistence.EntityManager" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="org.integrallis.gae.bookmarks.persistence.EMF" %>
<%@ page import="org.integrallis.gae.bookmarks.model.Bookmark" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%@page import="java.util.ArrayList"%>

<html>
  <head>
    <title>Bookmarks</title>
  </head>
  <body>
<%
UserService userService = UserServiceFactory.getUserService();
User user = userService.getCurrentUser();
String url = userService.createLoginURL(request.getRequestURI());
String urlLinktext = "Login";
List<Bookmark> bookmarks = new ArrayList<Bookmark>();
            
if (user != null){
    url = userService.createLogoutURL(request.getRequestURI());
    urlLinktext = "Logout";
    
    EntityManager em = EMF.get().createEntityManager();
    Query query = em.createQuery("SELECT FROM Bookmark b WHERE b.ownerId = :ownerId");
    query.setParameter("ownerId", user.getUserId());
    bookmarks = query.getResultList();
}
    
%>
<h1>GAE Bookmarks</h1>

<a href="<%=url %>"><%=urlLinktext%></a> <%=(user==null? "" : user.getNickname())%>

<% if (user != null) { %>
<h2>You have <%= bookmarks.size() %> bookmarks.</h2>

<table>
  <tr>
    <th>URL</th>
    <th>Created at</th>
  </tr>

  <% for (Bookmark bookmark : bookmarks) { %>
  <tr> 
    <td><%= bookmark.getUrl() %></td>
    <td><%= bookmark.getCreatedAt() %></td>
  </tr> 
  <% } %>
</table>

<hr />

<h2>New Bookmark</h2>

<form action="/new" method="post" accept-charset="utf-8">
  <table>
    <tr>
	  <td><label for="url">URL</label></td>
      <td><input type="text" name="url" id="url" size="100"/></td>
	</tr>
	<tr>
	  <td colspan="2" align="right"><input type="submit" value="Create"/></td>
	</tr>
  </table>
</form>

<% } else { %>
<h2>Please login with your Google account</h2>
<% } %>
</body>
</html>