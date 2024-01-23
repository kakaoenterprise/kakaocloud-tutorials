package com.kakaocloud.library.service;

import com.kakaocloud.library.dto.BookDto;
import com.kakaocloud.library.dto.CategoryDto;

import java.util.List;

public interface ManagementService {

  /**
   * Creates a book and saves it to the database.
   *
   * @param book The BookDto object representing the book to be created.
   * @return Returns true if the book is successfully created and saved, false otherwise.
   */
  boolean createBook(BookDto book);


  /**
   * Deletes a book from the database.
   *
   * @param bookId The ID of the book to be deleted.
   * @return Returns true if the book is successfully deleted, false otherwise.
   */
  boolean deleteBook(String bookId);

  /**
   * Updates a book.
   *
   * @param book The BookDto object representing the book to be updated.
   * @return Returns true if the book is successfully updated, false otherwise.
   */
  boolean updateBook(BookDto book);

  /**
   * Updates the status of a book in the management service.
   *
   * @param bookId The ID of the book to update.
   * @param status The new status of the book.
   * @return {@code true} if the book status was successfully updated, {@code false} otherwise.
   */
  boolean updateBookStatus(String bookId, String status);

  /**
   * Retrieves the status of a book based on its ID.
   *
   * @param bookId The ID of the book.
   * @return A BookDto object representing the book's status.
   */
  BookDto findBookStatus(String bookId);

  /**
   * Retrieves a list of books that match the given name.
   *
   * @param name The name of the books to search for.
   * @return A list of BookDto objects representing the found books.
   */
  List<BookDto> findBookList(String name);

  /**
   * Finds a list of books based on the given search type and search data.
   *
   * @param searchType The type of search to perform. Possible values: "도서명", "카테고리", "저자".
   * @param searchData The data to search for. The format will depend on the search type:
   *                   - 도서명: the name of the books to search for.
   *                   - 카테고리: the name of the category.
   *                   - 저자: the name of the writer.
   * @return A list of BookDto objects representing the found books. An empty list is returned if no books are found.
   */
  List<BookDto> findBookList(String searchType, String searchData);

  /**
   * Retrieves the detailed information of a book based on its ID.
   *
   * @param bookId The ID of the book.
   * @return A BookDto object representing the book's details.
   */
  BookDto findBookDetail(String bookId);

  /**
   * Retrieves all books.
   *
   * @return A list of BookDto objects representing all books.
   */
  List<BookDto> findAll();

  /**
   * Retrieves a list of all categories.
   *
   * @return A list of CategoryDto objects representing all categories.
   */
  List<CategoryDto> getCategoryList();

  /**
   * Retrieves a list of books that belong to the specified category.
   *
   * @param category The name of the category.
   * @return A list of BookDto objects representing the found books.
   */
  List<BookDto> findBookListByCategory(String category);

  /**
   * Retrieves a list of books marked as recommended.
   *
   * @return A list of BookDto objects representing the recommended books.
   */
  List<BookDto> findBookByRecommendedTrue();
}
