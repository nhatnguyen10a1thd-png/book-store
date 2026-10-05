package nguyen.vn.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import nguyen.vn.model.User_24110288;
import nguyen.vn.util.EmailUtil_24110288;

import java.io.IOException;
import java.util.Random;

@WebServlet(name = "RegisterController_24110288", urlPatterns = {"/register"})
public class RegisterController_24110288 extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/register.jsp").forward(request, response);
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
            request.getRequestDispatcher("/views/register.jsp").forward(request, response);
            return;
        }

        // Tạo OTP 6 số ngẫu nhiên
        Random random = new Random();
        int otpValue = 100000 + random.nextInt(900000);
        String otp = String.valueOf(otpValue);

        // Tạo đối tượng user tạm thời để lưu sau khi xác thực OTP
        User_24110288 pendingUser = new User_24110288();
        pendingUser.setFullname(fullname);
        pendingUser.setEmail(email);
        pendingUser.setPhone(phone);
        pendingUser.setPasswd(password);
        // Đăng ký mặc định là user bình thường
        pendingUser.setAdmin(false);

        // Lưu thông tin vào session
        HttpSession session = request.getSession();
        session.setAttribute("pendingUser", pendingUser);
        session.setAttribute("registrationOTP", otp);
        
        // Gửi email chứa OTP
        boolean emailSent = EmailUtil_24110288.sendOTP(email, otp);
        
        if (emailSent) {
            // Chuyển hướng đến trang xác thực OTP
            response.sendRedirect(request.getContextPath() + "/verify-otp");
        } else {
            // Lỗi gửi email
            session.removeAttribute("pendingUser");
            session.removeAttribute("registrationOTP");
            request.setAttribute("error", "Lỗi gửi email xác thực. Vui lòng cấu hình tài khoản gửi Email (App Password) trong EmailUtil_24110288.java!");
            request.getRequestDispatcher("/views/register.jsp").forward(request, response);
        }
    }
}
