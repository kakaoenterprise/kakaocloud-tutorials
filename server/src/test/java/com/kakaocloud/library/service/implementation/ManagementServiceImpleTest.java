package com.kakaocloud.library.service.implementation;

import com.kakaocloud.library.config.EmbeddedRedisConfig;
import com.kakaocloud.library.dto.BookDto;
import com.kakaocloud.library.dto.CategoryDto;
import com.kakaocloud.library.entity.BookEntity;
import com.kakaocloud.library.entity.CategoryEntity;
import com.kakaocloud.library.repository.BookRepository;

import com.kakaocloud.library.repository.CategoryRepository;
import com.kakaocloud.library.service.ManagementService;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;

@SpringBootTest
public class ManagementServiceImpleTest {

    @Autowired
    private ManagementService managementService;

    @MockBean
    private BookRepository bookRepository;

    @MockBean
    private CategoryRepository categoryRepository;

    @Test
    public void findBookStatusTest() {
        String status = "Available";
        BookEntity book = new BookEntity();
        book.setStatus(status);

        when(bookRepository.findByStatus(status)).thenReturn(book);

        BookDto result = managementService.findBookStatus(status);

        Assertions.assertNotNull(result);
        assertEquals(status, result.getStatus());
    }

    @Test
    public void testFindBookList() {

        BookEntity book = new BookEntity();
        book.setBookId("book-id");
        book.setName("book-name");

        when(bookRepository.findByNameContainingOrCategoryOrCompany(anyString(), anyString(), anyString()))
                .thenReturn(Collections.singletonList(book));

        List<BookDto> books = managementService.findBookList("book-name");

        assertEquals(1, books.size());
        assertEquals("book-id", books.getFirst().getBookId());
        assertEquals("book-name", books.getFirst().getName());
    }

    @Test
    void getCategoryList() {
        CategoryEntity categoryEntity1 = new CategoryEntity();
        categoryEntity1.setId("1");
        CategoryEntity categoryEntity2 = new CategoryEntity();
        categoryEntity2.setId("2");

        when(categoryRepository.findAll()).thenReturn(new ArrayList<>(Arrays.asList(categoryEntity1, categoryEntity2)));

        List<CategoryDto> categoryList = managementService.getCategoryList();

        assertEquals(2, categoryList.size());
        assertEquals(categoryEntity1.getId(), categoryList.get(0).getId());
        assertEquals(categoryEntity2.getId(), categoryList.get(1).getId());
    }

    @Test
    public void findBookListByCategoryTest() {
        ManagementService managementService = new ManagementServiceImple(bookRepository, null);
        BookDto bookDto1 = new BookDto();
        bookDto1.setBookId("JAVA-0001");
        bookDto1.setCategory("Java");
        BookDto bookDto2 = new BookDto();
        bookDto2.setBookId("JAVA-0002");
        bookDto2.setCategory("Java");
        List<BookEntity> bookEntityList = Arrays.asList(bookDto1.toEntity(), bookDto2.toEntity());
        when(bookRepository.findByCategory("Java")).thenReturn(bookEntityList);

        List<BookDto> result = managementService.findBookListByCategory("Java");

        verify(bookRepository, times(1)).findByCategory("Java");
        assertNotNull(result);
        assertEquals(2, result.size());
        for (BookDto bookDto : result) {
            assertEquals("Java", bookDto.getCategory());
        }
    }

    @Test
    public void findBookByRecommendedTrue() {
        BookEntity testBookEntity = new BookEntity();
        testBookEntity.setBookId("test-id");
        testBookEntity.setRecommended(true);

        List<BookEntity> bookEntityList = new ArrayList<>();
        bookEntityList.add(testBookEntity);

        when(bookRepository.findByRecommendedTrue()).thenReturn(bookEntityList);

        List<BookDto> result = managementService.findBookByRecommendedTrue();

        assertEquals(1, result.size());
        assertEquals(testBookEntity.getBookId(), result.getFirst().getBookId());
        assertEquals(testBookEntity.isRecommended(), result.getFirst().isRecommended());

    }

}