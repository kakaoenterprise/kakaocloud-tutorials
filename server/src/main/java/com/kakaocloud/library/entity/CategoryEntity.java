package com.kakaocloud.library.entity;

import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.relational.core.mapping.Table;

import java.io.Serial;
import java.io.Serializable;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Entity(name = "category")
public class CategoryEntity implements Serializable {
  @Serial
  private static final long serialVersionUID = 1L;

  @Id
  @JsonProperty
  private String id;

  @Column
  @JsonProperty
  private String name;
}
