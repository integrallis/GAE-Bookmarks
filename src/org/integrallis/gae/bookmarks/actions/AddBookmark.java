package org.integrallis.gae.bookmarks.actions;

import java.io.IOException;
import java.util.Calendar;

import javax.persistence.EntityManager;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.integrallis.gae.bookmarks.persistence.EMF;
import org.integrallis.gae.bookmarks.model.Bookmark;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

@SuppressWarnings("serial")
public class AddBookmark extends HttpServlet {

	@Override
	public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		String url = req.getParameter("url");
		
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		Bookmark bookmark = new Bookmark(url, Calendar.getInstance().getTime(), user.getUserId());
		EntityManager em = EMF.get().createEntityManager();
		try {
			em.persist(bookmark);
		} finally {
			em.close();
		}
		resp.sendRedirect("/Bookmarks.jsp");
	}

}
