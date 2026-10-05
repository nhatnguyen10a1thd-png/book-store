package nguyen.vn.model;

import java.util.Date;

public class Author_24110288 {
    private int authorId;
    private String authorName;
    private Date dateOfBirth;

    public Author_24110288() {
    }

    public Author_24110288(int authorId, String authorName, Date dateOfBirth) {
        this.authorId = authorId;
        this.authorName = authorName;
        this.dateOfBirth = dateOfBirth;
    }

    public int getAuthorId() { return authorId; }
    public void setAuthorId(int authorId) { this.authorId = authorId; }

    public String getAuthorName() { return authorName; }
    public void setAuthorName(String authorName) { this.authorName = authorName; }

    public Date getDateOfBirth() { return dateOfBirth; }
    public void setDateOfBirth(Date dateOfBirth) { this.dateOfBirth = dateOfBirth; }
}
