package nguyen.vn.service;

import nguyen.vn.model.Author_24110288;
import nguyen.vn.repository.AuthorRepository_24110288;
import nguyen.vn.repository.IAuthorRepository_24110288;

import java.util.List;

public class AuthorService_24110288 implements IAuthorService_24110288 {
    
    private final IAuthorRepository_24110288 authorRepository = new AuthorRepository_24110288();

    @Override
    public List<Author_24110288> getAllAuthors() {
        return authorRepository.getAllAuthors();
    }

    @Override
    public List<Author_24110288> getAuthorsByPage(int page, int limit) {
        int offset = (page - 1) * limit;
        return authorRepository.getAuthorsByPage(offset, limit);
    }

    @Override
    public int getTotalAuthors() {
        return authorRepository.getTotalAuthors();
    }

    @Override
    public Author_24110288 getAuthorById(int authorId) {
        return authorRepository.getAuthorById(authorId);
    }

    @Override
    public boolean addAuthor(Author_24110288 author) {
        return authorRepository.addAuthor(author);
    }

    @Override
    public boolean updateAuthor(Author_24110288 author) {
        return authorRepository.updateAuthor(author);
    }

    @Override
    public boolean deleteAuthor(int authorId) {
        return authorRepository.deleteAuthor(authorId);
    }
}
