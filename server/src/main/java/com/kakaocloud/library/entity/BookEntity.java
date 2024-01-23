package com.kakaocloud.library.entity;

import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import lombok.*;
import org.springframework.format.annotation.DateTimeFormat;

import java.io.Serial;
import java.io.Serializable;
import java.util.Date;

@Data
@Builder
@NoArgsConstructor(access = AccessLevel.PUBLIC)
@AllArgsConstructor
@Entity(name = "book")
public class BookEntity implements Serializable {

  @Serial
  private static final long serialVersionUID = 1L;

  @Id
  private String bookId;

  @JsonProperty
  private String category;

  @JsonProperty
  private String name;

  //@DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss")
  @JsonProperty
  @DateTimeFormat(pattern = "yyyy-MM-dd")
  private Date publishDate;

  @JsonProperty
  private String company;

  @JsonProperty
  private String writer;

  @JsonProperty
  private String status;

  @JsonProperty
  private int quantity;

  @JsonProperty
  private boolean recommended;

  @JsonProperty
  private String imageUrl;
}
