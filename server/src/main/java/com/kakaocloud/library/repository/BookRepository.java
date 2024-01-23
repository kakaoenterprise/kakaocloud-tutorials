package com.kakaocloud.library.repository;

import com.kakaocloud.library.entity.BookEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository("BookRepository")
public interface BookRepository extends CrudRepository<BookEntity, String>, JpaRepository<BookEntity, String> {

  BookEntity findByStatus(String bookId);

  List<BookEntity> findByNameContainingOrCategoryOrCompany(String name, String category, String company);

  BookEntity findByBookId(String bookId);

  List<BookEntity> findByCategory(String category);

  List<BookEntity> findByName(String name);

  List<BookEntity> findByNameContainsIgnoreCase(String name);

  List<BookEntity> findByWriter(String writer);

  List<BookEntity> findByRecommendedTrue();
}
