package com.liuyanzhao.ssm.blog.dto;

import lombok.Data;

/**
 * @author 言曌
 * @date 2017/11/30 下午7:04
 */

@Data
public class ResultVO<T> {

    /**
     * 错误码
     */
    private Integer code;

    /**
     * 提示信息
     */
    private String msg;

    /**
     * 返回的具体内容
     */
    private T location;


    public ResultVO(Integer code, String msg, T location) {
        this.code = code;
        this.msg = msg;
        this.location = location;
    }

    public ResultVO() {
    }
}
