package com.kakaocloud.library.controller;

import com.kakaocloud.library.dto.BookDto;
import com.kakaocloud.library.dto.CategoryDto;
import com.kakaocloud.library.service.ManagementService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1.0/management")
@RequiredArgsConstructor
public class ManagementController {

  private final ManagementService managementService;

  /**
   * Retrieves all books.
   *
   * @return A ResponseEntity containing a list of BookDto objects representing all books,
   *         with HttpStatus.OK status code.
   */
  @GetMapping(value = "/book/all", produces = {MediaType.APPLICATION_JSON_VALUE})
  public ResponseEntity<List<BookDto>> getAllBooks() {
    List<BookDto> books = managementService.findAll();
    return new ResponseEntity<>(books, HttpStatus.OK);
  }

  /**
   * Retrieves all categories.
   *
   * @return A ResponseEntity containing a list of CategoryDto objects representing all categories,
   *         with HttpStatus.OK status code.
   */
  @GetMapping(value = "/category/all", produces = {MediaType.APPLICATION_JSON_VALUE})
  public ResponseEntity<List<CategoryDto>> getAllCategorys() {
    List<CategoryDto> categories = managementService.getCategoryList();
    return new ResponseEntity<>(categories, HttpStatus.OK);
  }

  /**
   * Creates a book and saves it to the database.
   *
   * @param book The BookDto object representing the book to be created.
   * @return Returns a ResponseEntity containing a boolean value indicating whether the book is successfully created and saved, with HttpStatus.OK status code.
   */
  @PostMapping(value = "/book", produces = {MediaType.APPLICATION_JSON_VALUE})
  public ResponseEntity<Boolean> createBook(BookDto book) {
    return new ResponseEntity<>(managementService.createBook(book), HttpStatus.OK);
  }

  /**
   * Deletes a book from the database.
   *
   * @param bookId The ID of the book to be deleted.
   * @return Returns true if the book is successfully deleted, false otherwise.
   */
  @DeleteMapping(value = "/book", produces = {MediaType.APPLICATION_JSON_VALUE})
  public ResponseEntity<Boolean> deleteBook(String bookId) {
    return new ResponseEntity<>(managementService.deleteBook(bookId), HttpStatus.OK);
  }


  /**
   * Updates a book.
   *
   * @param book The BookDto object representing the book to be updated.
   * @return Returns a ResponseEntity containing a boolean value indicating whether the book is successfully updated,
   *         with HttpStatus.OK status code.
   * @see ManagementController
   * @see BookDto
   * @see ManagementService#updateBook(BookDto)
   */
  @PutMapping(value = "/book", produces = {MediaType.APPLICATION_JSON_VALUE})
  public ResponseEntity<Boolean> updateBook(BookDto book) {
    return new ResponseEntity<>(managementService.updateBook(book), HttpStatus.OK);
  }

  /**
   * Updates the status of a book.
   *
   * @param bookId The ID of the book to update.
   * @param status The new status of the book.
   * @return A ResponseEntity containing a boolean value indicating whether the book status was successfully updated,
   *         with HttpStatus.OK status code.
   */
  @PutMapping(value = "/book/status/{bookId}/{status}", produces = {MediaType.APPLICATION_JSON_VALUE})
  public ResponseEntity<Boolean> updateBookStatus(@PathVariable String bookId, @PathVariable String status) {
    return new ResponseEntity<>(managementService.updateBookStatus(bookId, status), HttpStatus.OK);
  }

  /**
   * Retrieves the status of a book based on its ID.
   *
   * @param bookId The ID of the book.
   * @return A ResponseEntity containing a BookDto object representing the book's status, with HttpStatus.OK status code.
   */
  @GetMapping(value = "/book/status/{bookId}", produces = {MediaType.APPLICATION_JSON_VALUE})
  public ResponseEntity<BookDto> findBookStatus(@PathVariable String bookId) {
    BookDto book = managementService.findBookStatus(bookId);
    return new ResponseEntity<>(book, HttpStatus.OK);
  }

  /**
   * Retrieves a list of books that match the given name.
   *
   * @param name The name of the books to search for.
   * @return A ResponseEntity containing a list of BookDto objects representing the found books, with HttpStatus.OK status code.
   */
  @GetMapping(value = "/books/{name}", produces = {MediaType.APPLICATION_JSON_VALUE})
  public ResponseEntity<List<BookDto>> findBookList(@PathVariable String name) {
    List<BookDto> books = managementService.findBookList(name);
    return new ResponseEntity<>(books, HttpStatus.OK);
  }

  /**
   * Retrieves the detailed information of a book based on its ID.
   *
   * @param bookId The ID of the book.
   * @return A ResponseEntity containing a BookDto object representing the book's details,
   *         with HttpStatus.OK status code.
   */
  @GetMapping(value = "/book/{bookId}", produces = {MediaType.APPLICATION_JSON_VALUE})
  public ResponseEntity<BookDto> findBookDetail(@PathVariable String bookId) {
    BookDto book = managementService.findBookDetail(bookId);
    return new ResponseEntity<>(book, HttpStatus.OK);
  }

  /**
   * Retrieves a list of books that belong to a specific category.
   *
   * @param name The name of the category.
   * @return A ResponseEntity containing a list of BookDto objects representing the found books, with HttpStatus.OK status code.
   */
  @GetMapping(value = "/book/category/{name}", produces = {MediaType.APPLICATION_JSON_VALUE})
  public ResponseEntity<List<BookDto>> findBooksByCategory(@PathVariable String name) {
    List<BookDto> books = managementService.findBookListByCategory(name);
    return new ResponseEntity<>(books, HttpStatus.OK);
  }
}
