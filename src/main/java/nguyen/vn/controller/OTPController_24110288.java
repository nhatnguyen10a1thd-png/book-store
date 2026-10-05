package nguyen.vn.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import nguyen.vn.model.User_24110288;
import nguyen.vn.service.IUserService_24110288;
import nguyen.vn.service.UserService_24110288;

import java.io.IOException;

@WebServlet(name = "OTPController_24110288", urlPatterns = {"/verify-otp"})
public class OTPController_24110288 extends HttpServlet {

    private final IUserService_24110288 userService = new UserService_24110288();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("pendingUser") == null) {
            response.sendRedirect(request.getContextPath() + "/register");
            return;
        }
        request.getRequestDispatcher("/WEB-INF/views/verify-otp.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String enteredOtp = request.getParameter("otp");
        HttpSession session = request.getSession();
        
        String sessionOtp = (String) session.getAttribute("registrationOTP");
        User_24110288 pendingUser = (User_24110288) session.getAttribute("pendingUser");
        Long expiresAt = (Long) session.getAttribute("registrationOTPExpiresAt");

        if (sessionOtp == null || pendingUser == null || expiresAt == null) {
            request.setAttribute("error", "Phiên xác thực đã hết hạn. Vui lòng đăng ký lại.");
            request.getRequestDispatcher("/WEB-INF/views/verify-otp.jsp").forward(request, response);
            return;
        }

        if (System.currentTimeMillis() > expiresAt) {
            clearPendingRegistration(session);
            request.setAttribute("error", "Mã OTP đã hết hạn. Vui lòng đăng ký lại.");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }

        if (sessionOtp.equals(enteredOtp)) {
            boolean success = userService.register(pendingUser);
            
            if (success) {
                clearPendingRegistration(session);
                
                request.setAttribute("message", "Đăng ký thành công! Vui lòng đăng nhập.");
                request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Không thể hoàn tất đăng ký lúc này. Vui lòng thử lại.");
                request.getRequestDispatcher("/WEB-INF/views/verify-otp.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("error", "Mã OTP không chính xác. Vui lòng nhập lại.");
            request.getRequestDispatcher("/WEB-INF/views/verify-otp.jsp").forward(request, response);
        }
    }

    private void clearPendingRegistration(HttpSession session) {
        session.removeAttribute("pendingUser");
        session.removeAttribute("registrationOTP");
        session.removeAttribute("registrationOTPExpiresAt");
    }
}
