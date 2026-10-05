package nguyen.vn.repository;

import nguyen.vn.model.Rating_24110288;
import java.util.List;

public interface IRatingRepository_24110288 {
    List<Rating_24110288> getRatingsByBookId(int bookId);
    boolean addRating(Rating_24110288 rating);
}
