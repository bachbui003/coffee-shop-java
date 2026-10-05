package vn.coffee;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;
import java.io.IOException;

@WebFilter("/*")
public class SecurityFilter implements Filter {
    public void doFilter(ServletRequest input, ServletResponse output, FilterChain chain) throws IOException, ServletException {
        var req = (HttpServletRequest) input;
        var res = (HttpServletResponse) output;
        req.setCharacterEncoding("UTF-8");
        res.setCharacterEncoding("UTF-8");
        res.setHeader("X-Content-Type-Options", "nosniff");
        res.setHeader("X-Frame-Options", "DENY");
        res.setHeader("Referrer-Policy", "same-origin");
        res.setHeader("Content-Security-Policy", "default-src 'self'; script-src 'self'; style-src 'self'; img-src 'self' data:; connect-src 'self'; frame-ancestors 'none'; base-uri 'self'; form-action 'self'");
        String path = req.getRequestURI().substring(req.getContextPath().length());
        if (path.equals("/") || path.equals("/index.html") || path.equals("/admin") || path.equals("/admin/") || path.equals("/admin.html") || path.matches("/assets/[a-zA-Z0-9_.-]+") || path.startsWith("/api/")) {
            if (path.equals("/admin/")) res.sendRedirect(req.getContextPath()+"/admin");
            else if (path.equals("/admin")) req.getRequestDispatcher("/admin.html").forward(req, res);
            else chain.doFilter(req,res);
        } else {
            res.sendError(404);
        }
    }
}
