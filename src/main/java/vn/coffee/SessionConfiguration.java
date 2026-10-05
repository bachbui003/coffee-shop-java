package vn.coffee;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

@WebListener
public class SessionConfiguration implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent event) {
        if (Boolean.parseBoolean(System.getenv("COFFEE_COOKIE_SECURE"))) {
            event.getServletContext().getSessionCookieConfig().setSecure(true);
        }
    }
}
