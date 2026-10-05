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
            // Chưa đăng ký nhưng lại truy cập trang xác thực
            response.sendRedirect(request.getContextPath() + "/register");
            return;
        }
        request.getRequestDispatcher("/views/verify-otp.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String enteredOtp = request.getParameter("otp");
        HttpSession session = request.getSession();
        
        String sessionOtp = (String) session.getAttribute("registrationOTP");
        User_24110288 pendingUser = (User_24110288) session.getAttribute("pendingUser");

        if (sessionOtp == null || pendingUser == null) {
            request.setAttribute("error", "Phiên xác thực đã hết hạn. Vui lòng đăng ký lại.");
            request.getRequestDispatcher("/views/verify-otp.jsp").forward(request, response);
            return;
        }

        if (sessionOtp.equals(enteredOtp)) {
            // Xác thực thành công, lưu vào database
            boolean success = userService.register(pendingUser);
            
            if (success) {
                // Xoá session tạm thời
                session.removeAttribute("pendingUser");
                session.removeAttribute("registrationOTP");
                
                request.setAttribute("message", "Đăng ký thành công! Vui lòng đăng nhập.");
                request.getRequestDispatcher("/views/login.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi lưu vào CSDL. Vui lòng thử lại!");
                request.getRequestDispatcher("/views/verify-otp.jsp").forward(request, response);
            }
        } else {
            // Nhập sai mã OTP
            request.setAttribute("error", "Mã OTP không chính xác. Vui lòng nhập lại.");
            request.getRequestDispatcher("/views/verify-otp.jsp").forward(request, response);
        }
    }
}
