package nguyen.vn.repository;

import nguyen.vn.model.Author_24110288;
import java.util.List;

public interface IAuthorRepository_24110288 {
    List<Author_24110288> getAllAuthors();
    List<Author_24110288> getAuthorsByPage(int offset, int limit);
    int getTotalAuthors();
    Author_24110288 getAuthorById(int authorId);
    boolean addAuthor(Author_24110288 author);
    boolean updateAuthor(Author_24110288 author);
    boolean deleteAuthor(int authorId);
}
