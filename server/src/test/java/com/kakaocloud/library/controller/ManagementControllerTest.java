package com.kakaocloud.library.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.kakaocloud.library.config.EmbeddedRedisConfig;
import com.kakaocloud.library.dto.BookDto;
import com.kakaocloud.library.dto.CategoryDto;
import com.kakaocloud.library.service.ManagementService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.mock.web.MockHttpServletResponse;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import java.util.Arrays;
import java.util.Collections;
import java.util.Date;
import java.util.List;

import static org.assertj.core.api.AssertionsForClassTypes.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.BDDMockito.given;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
public class ManagementControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    ObjectMapper objectMapper;

    @MockBean
    private ManagementService managementService;

    @Autowired
    private ManagementController managementController;

    @Test
    void createBookTest() throws Exception {
        BookDto bookDto = new BookDto();
        bookDto.setBookId("1");
        bookDto.setName("Test book");
        bookDto.setWriter("Test Writer");

        when(managementService.createBook(any())).thenReturn(true);

        mockMvc.perform(post("/api/v1.0/management/book")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"bookId\":\"1\",\"name\":\"Test book\",\"writer\":\"Test Writer\"}"))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").value(true));
    }

    @Test
    public void testGetAllBooks() throws Exception {
        BookDto bookDto1 = new BookDto();
        bookDto1.setBookId("1");
        bookDto1.setName("Book One");

        BookDto bookDto2 = new BookDto();
        bookDto2.setBookId("2");
        bookDto2.setName("Book Two");

        List<BookDto> mockBookList = Arrays.asList(bookDto1, bookDto2);

        when(managementService.findAll()).thenReturn(mockBookList);

        mockMvc.perform(get("/api/v1.0/management/book/all").accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$[0].bookId").exists())
                .andExpect(jsonPath("$[0].bookId").value("1"))
                .andExpect(jsonPath("$[0].name").value("Book One"))
                .andExpect(jsonPath("$[1].bookId").exists())
                .andExpect(jsonPath("$[1].bookId").value("2"))
                .andExpect(jsonPath("$[1].name").value("Book Two"));
    }

    @Test
    void deleteBook_shouldReturnHttpStatusOk_whenBookExists() throws Exception {
        String existingBookId = "1";
        given(managementService.deleteBook(existingBookId)).willReturn(true);

        mockMvc.perform(delete("/api/v1.0/management/book")
                        .param("bookId", existingBookId)
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(content().string("true"));
    }

    @Test
    void deleteBook_shouldReturnHttpStatusOk_whenBookDoesntExist() throws Exception {
        String nonExistingBookId = "2";
        given(managementService.deleteBook(nonExistingBookId)).willReturn(false);

        mockMvc.perform(delete("/api/v1.0/management/book")
                        .param("bookId", nonExistingBookId)
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(content().string("false"));
    }

    @Test
    public void testGetAllCategorys() throws Exception {
        CategoryDto category1 = new CategoryDto();
        category1.setName("category 1");
        CategoryDto category2 = new CategoryDto();
        category2.setName("category 2");

        List<CategoryDto> allCategorys = Arrays.asList(category1, category2);

        given(managementService.getCategoryList()).willReturn(allCategorys);

        mockMvc.perform(get("/api/v1.0/management/category/all")
                        .contentType(MediaType.APPLICATION_JSON_VALUE))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON_VALUE))
                .andExpect(jsonPath("$[0].name").value(category1.getName()))
                .andExpect(jsonPath("$[1].name").value(category2.getName()));
    }

    @Test
    void updateBook() throws Exception {
        BookDto bookDto = BookDto.builder()
                .bookId("BOOK001")
                .category("Science")
                .name("Science for All")
                .publishDate(new Date())
                .company("BigBooks Inc.")
                .writer("WriterOne")
                .status("Available")
                .quantity(1)
                .recommended(true)
                .imageUrl("www.imageurl.com/img1")
                .build();

        given(managementService.updateBook(any(BookDto.class))).willReturn(true);

        mockMvc.perform(put("/api/v1.0/management/book")
                        .contentType(MediaType.APPLICATION_JSON_VALUE)
                        .content(objectMapper.writeValueAsString(bookDto)))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").value(true));
    }

    @Test
    public void findBookStatus_WhenBookExists_ReturnsBookStatus() throws Exception {
        String expectedBookId = "1";
        String expectedStatus = "Available";
        BookDto expectedBook = BookDto.builder()
                .bookId(expectedBookId)
                .category("Fiction")
                .name("Harry Potter")
                .publishDate(new Date())
                .company("Bloomsbury")
                .writer("J.K. Rowling")
                .status(expectedStatus)
                .quantity(3)
                .recommended(true)
                .imageUrl("http://example.com/image.jpg")
                .build();
        when(managementService.findBookStatus(expectedBookId)).thenReturn(expectedBook);

        MockHttpServletResponse response = mockMvc.perform(
                MockMvcRequestBuilders.get("/api/v1.0/management/book/status/{bookId}", expectedBookId)
                        .contentType(MediaType.APPLICATION_JSON)).andReturn().getResponse();

        assertThat(response.getStatus()).isEqualTo(HttpStatus.OK.value());
        assertThat(response.getContentAsString()).contains(expectedStatus);
    }

    @Test
    void findBookList() throws Exception {
        BookDto bookDto = new BookDto();
        bookDto.setName("Book_Name");
        List<BookDto> bookList = Collections.singletonList(bookDto);

        given(managementService.findBookList(anyString())).willReturn(bookList);

        mockMvc.perform(get("/api/v1.0/management/books/{name}", "Book_Name")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].name").value(bookDto.getName()));
    }

    @Test
    void testFindBookDetail() throws Exception {

        BookDto book = BookDto.builder()
                .bookId("book1")
                .category("fiction")
                .name("Test Book")
                .company("Test Company")
                .writer("Test Writer")
                .status("available")
                .quantity(2)
                .recommended(false)
                .imageUrl("test.jpg")
                .build();

        when(managementService.findBookDetail("book1")).thenReturn(book);

        mockMvc = MockMvcBuilders.standaloneSetup(managementController).build();

        mockMvc.perform(get("/api/v1.0/management/book/book1")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andDo(print())
                .andExpect(jsonPath("$.bookId").value(book.getBookId()))
                .andExpect(jsonPath("$.category").value(book.getCategory()))
                .andExpect(jsonPath("$.name").value(book.getName()))
                .andExpect(jsonPath("$.company").value(book.getCompany()))
                .andExpect(jsonPath("$.writer").value(book.getWriter()))
                .andExpect(jsonPath("$.status").value(book.getStatus()))
                .andExpect(jsonPath("$.quantity").value(book.getQuantity()))
                .andExpect(jsonPath("$.recommended").value(book.isRecommended()))
                .andExpect(jsonPath("$.imageUrl").value(book.getImageUrl()));
    }

    @Test
    public void testFindBooksByCategory() throws Exception {
        BookDto book1 = new BookDto();
        book1.setBookId("1");
        book1.setName("Book 1");
        book1.setWriter("Author 1");

        BookDto book2 = new BookDto();
        book2.setBookId("2");
        book2.setName("Book 2");
        book2.setWriter("Author 2");

        List<BookDto> books = Arrays.asList(book1, book2);
        when(managementService.findBookListByCategory(anyString())).thenReturn(books);

        mockMvc.perform(get("/api/v1.0/management/book/category/Fiction"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").isNotEmpty())
                .andExpect(jsonPath("$[0].bookId").value(book1.getBookId()))
                .andExpect(jsonPath("$[0].writer").value(book1.getWriter()))
                .andExpect(jsonPath("$[1].bookId").value(book2.getBookId()))
                .andExpect(jsonPath("$[1].writer").value(book2.getWriter()));
    }
}