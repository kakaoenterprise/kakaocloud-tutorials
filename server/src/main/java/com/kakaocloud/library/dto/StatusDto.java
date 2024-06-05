package com.kakaocloud.library.dto;

import lombok.*;

@Getter
@Setter
@Builder
public class StatusDto {

    @Builder.Default
    Boolean status = true;
}
