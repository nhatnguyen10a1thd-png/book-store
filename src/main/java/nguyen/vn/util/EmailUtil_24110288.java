package nguyen.vn.util;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

public class EmailUtil_24110288 {

    private static final Logger LOGGER = Logger.getLogger(EmailUtil_24110288.class.getName());
    private static final String SMTP_EMAIL_SETTING = "BOOKSTORE_SMTP_EMAIL";
    private static final String SMTP_PASSWORD_SETTING = "BOOKSTORE_SMTP_APP_PASSWORD";

    public static boolean sendOTP(String recipientEmail, String otp) {
        String senderEmail = getSetting(SMTP_EMAIL_SETTING);
        String senderPassword = getSetting(SMTP_PASSWORD_SETTING);
        if (senderEmail == null || senderPassword == null) {
            LOGGER.severe("Thiếu cấu hình tài khoản gửi email.");
            return false;
        }

        Properties properties = new Properties();
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.starttls.enable", "true");
        properties.put("mail.smtp.host", "smtp.gmail.com");
        properties.put("mail.smtp.port", "587");
        properties.put("mail.smtp.ssl.protocols", "TLSv1.2");

        Session session = Session.getInstance(properties, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(senderEmail, senderPassword);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(senderEmail));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject("Xác thực tài khoản BookStore - Mã OTP của bạn");

            String htmlContent = "<h2>Chào mừng bạn đến với BookStore!</h2>"
                    + "<p>Mã OTP để kích hoạt tài khoản của bạn là: <strong style='font-size:24px; color:#0d6efd'>"
                    + otp + "</strong></p>"
                    + "<p>Mã này sẽ hết hạn sau 5 phút.</p>";

            message.setContent(htmlContent, "text/html; charset=utf-8");

            Transport.send(message);
            return true;
        } catch (MessagingException exception) {
            LOGGER.log(Level.SEVERE, "Không thể gửi email xác thực.", exception);
            return false;
        }
    }

    private static String getSetting(String name) {
        String value = System.getenv(name);
        if (value == null || value.isBlank()) {
            value = System.getProperty(name);
        }
        return value == null || value.isBlank() ? null : value;
    }
}
