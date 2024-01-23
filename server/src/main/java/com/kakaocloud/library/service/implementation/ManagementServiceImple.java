package com.kakaocloud.library.service.implementation;

import com.kakaocloud.library.dto.BookDto;
import com.kakaocloud.library.dto.CategoryDto;
import com.kakaocloud.library.entity.BookEntity;
import com.kakaocloud.library.repository.BookRepository;
import com.kakaocloud.library.repository.CategoryRepository;
import com.kakaocloud.library.service.ManagementService;
import com.kakaocloud.library.util.DateFormatter;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service("ManagementService")
@RequiredArgsConstructor
public class ManagementServiceImple implements ManagementService {

  private final BookRepository bookRepository;
  private final CategoryRepository categoryRepository;

  public boolean createBook(BookDto book) {
    if (0 < book.getQuantity())
      book.setStatus("최초등록");
    for (int i = 1; i <= book.getQuantity(); i++) {
      book.setBookId(book.getCategory() + "-" + DateFormatter.getDateToString(book.getPublishDate()) + "-" + i);
      bookRepository.save(book.toEntity());
    }
    return true;
  }

  public boolean deleteBook(String bookId) {
    bookRepository.deleteById(bookId);
    return true;
  }

  public boolean updateBook(BookDto book) {
    bookRepository.save(book.toEntity());
    return true;
  }

  public boolean updateBookStatus(String bookId, String status) {
    BookEntity book = bookRepository.findByBookId(bookId);
    book.setStatus(status);
    bookRepository.save(book);
    return true;
  }

  public BookDto findBookStatus(String bookId) {
    ModelMapper modelMapper = new ModelMapper();
    return modelMapper.map(bookRepository.findByStatus(bookId), BookDto.class);
  }

  public List<BookDto> findBookList(String search) {
    ModelMapper modelMapper = new ModelMapper();
    List<BookEntity> bookList = bookRepository.findByNameContainingOrCategoryOrCompany(search, search, search);
    return bookList.stream().map(book1 -> modelMapper.map(book1, BookDto.class)).collect(Collectors.toList());
  }

  public List<BookDto> findBookList(String searchType, String searchData) {
    List<BookDto> books = null;
    ModelMapper modelMapper = new ModelMapper();
    if ("도서명".equals(searchType))
      books = bookRepository.findByNameContainsIgnoreCase(searchData)
              .stream()
              .map(book -> modelMapper.map(book, BookDto.class))
              .collect(Collectors.toList());
    if ("카테고리".equals(searchType))
      books = bookRepository.findByCategory(searchData)
              .stream()
              .map(book -> modelMapper.map(book, BookDto.class))
              .collect(Collectors.toList());
    if ("저자".equals(searchType))
      books = bookRepository.findByWriter(searchData)
              .stream()
              .map(book -> modelMapper.map(book, BookDto.class))
              .collect(Collectors.toList());
    return books;
  }

  public BookDto findBookDetail(String bookId) {
    ModelMapper modelMapper = new ModelMapper();
    return modelMapper.map(bookRepository.findByBookId(bookId), BookDto.class);
  }

  public List<BookDto> findAll() {
    ModelMapper modelMapper = new ModelMapper();
    return bookRepository.findAll()
            .stream()
            .map(book1 -> modelMapper.map(book1, BookDto.class))
            .collect(Collectors.toList());
  }

  @Override
  public List<CategoryDto> getCategoryList() {
    ModelMapper modelMapper = new ModelMapper();
    return categoryRepository
            .findAll()
            .stream()
            .map(category -> modelMapper.map(category, CategoryDto.class))
            .collect(Collectors.toList());
  }

  @Override
  public List<BookDto> findBookListByCategory(String category) {
    ModelMapper modelMapper = new ModelMapper();
      return bookRepository
            .findByCategory(category)
            .stream()
            .map(book1 -> modelMapper.map(book1, BookDto.class))
            .collect(Collectors.toList());
  }

  @Override
  public List<BookDto> findBookByRecommendedTrue() {
    ModelMapper modelMapper = new ModelMapper();
      return bookRepository
            .findByRecommendedTrue()
            .stream()
            .map(book1 -> modelMapper.map(book1, BookDto.class))
            .collect(Collectors.toList());
  }

}
