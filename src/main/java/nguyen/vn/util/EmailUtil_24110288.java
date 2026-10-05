package nguyen.vn.util;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import java.util.Properties;

public class EmailUtil_24110288 {

    // THAY ĐỔI EMAIL VÀ APP PASSWORD Ở ĐÂY
    private static final String SENDER_EMAIL = "nhatnguyen10a1thd@gmail.com";
    private static final String SENDER_PASSWORD = "iovflanothwdmmgg";

    public static boolean sendOTP(String recipientEmail, String otp) {
        Properties properties = new Properties();
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.starttls.enable", "true");
        properties.put("mail.smtp.host", "smtp.gmail.com");
        properties.put("mail.smtp.port", "587");
        properties.put("mail.smtp.ssl.protocols", "TLSv1.2");

        Session session = Session.getInstance(properties, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SENDER_EMAIL, SENDER_PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SENDER_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject("Xác thực tài khoản BookStore - Mã OTP của bạn");

            String htmlContent = "<h2>Chào mừng bạn đến với BookStore!</h2>"
                    + "<p>Mã OTP để kích hoạt tài khoản của bạn là: <strong style='font-size:24px; color:#0d6efd'>"
                    + otp + "</strong></p>"
                    + "<p>Mã này sẽ hết hạn sau 5 phút.</p>";

            message.setContent(htmlContent, "text/html; charset=utf-8");

            Transport.send(message);
            return true;
        } catch (MessagingException e) {
            e.printStackTrace();
            return false;
        }
    }
}
