package nguyen.vn.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import nguyen.vn.model.User_24110288;
import nguyen.vn.util.EmailUtil_24110288;

import java.io.IOException;
import java.security.SecureRandom;

@WebServlet(name = "RegisterController_24110288", urlPatterns = {"/register"})
public class RegisterController_24110288 extends HttpServlet {

    private static final SecureRandom SECURE_RANDOM = new SecureRandom();
    private static final long OTP_VALIDITY_MILLIS = 5 * 60 * 1000L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        String fullname = request.getParameter("fullname");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp!");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }

        String otp = String.format("%06d", SECURE_RANDOM.nextInt(1_000_000));

        User_24110288 pendingUser = new User_24110288();
        pendingUser.setFullname(fullname);
        pendingUser.setEmail(email);
        pendingUser.setPhone(phone);
        pendingUser.setPasswd(password);
        pendingUser.setAdmin(false);

        HttpSession session = request.getSession();
        session.setAttribute("pendingUser", pendingUser);
        session.setAttribute("registrationOTP", otp);
        session.setAttribute("registrationOTPExpiresAt", System.currentTimeMillis() + OTP_VALIDITY_MILLIS);
        
        boolean emailSent = EmailUtil_24110288.sendOTP(email, otp);
        
        if (emailSent) {
            response.sendRedirect(request.getContextPath() + "/verify-otp");
        } else {
            session.removeAttribute("pendingUser");
            session.removeAttribute("registrationOTP");
            session.removeAttribute("registrationOTPExpiresAt");
            request.setAttribute("error", "Không thể gửi email xác thực lúc này. Vui lòng thử lại sau.");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
        }
    }
}
