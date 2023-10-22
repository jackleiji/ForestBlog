<%--保留此处 start--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="rapid" uri="http://www.rapid-framework.org.cn/rapid" %>
<%--保留此处 end--%>
<rapid:override name="title">
    - 编辑页面
</rapid:override>

<rapid:override name="content">
    <blockquote class="layui-elem-quote">
        <span class="layui-breadcrumb" lay-separator="/">
              <a href="/admin">首页</a>
              <a href="/admin/page">页面列表</a>
              <a><cite>新建页面</cite></a>
        </span>
    </blockquote>


    <form class="layui-form" method="post" id="myForm"
          action="/admin/page/insertSubmit">
        <div class="layui-form-item">
            <label class="layui-form-label">别名<span style="color: #FF5722; ">*</span></label>
            <div class="layui-input-inline">
                <input type="text" name="pageKey" lay-verify="key" id="key" value=""
                       class="layui-input">
            </div>
            <div class="layui-form-mid layui-word-aux">请填写2到20位，仅允许字母、下划线和减号组成（<span style="color: #FF5722;">请确保别名没重复</span>）</div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">标题 <span style="color: #FF5722; ">*</span></label>
            <div class="layui-input-inline">
                <input type="text" name="pageTitle" lay-verify="title" id="title" value=""
                       class="layui-input">
            </div>
        </div>

        <div class="layui-form-item layui-form-text">
            <label class="layui-form-label">内容 <span style="color: #FF5722; ">*</span></label>
            <div class="layui-input-block">
                <textarea class="layui-textarea layui-hide" name="pageContent"
                          id="content"></textarea>
            </div>
        </div>

        <div class="layui-form-item">
            <div class="layui-input-block">
                <button class="layui-btn" lay-submit="" lay-filter="demo1">新建</button>
                <button type="reset" class="layui-btn layui-btn-primary">重置</button>
            </div>
        </div>
    </form>

</rapid:override>


<rapid:override name="footer-script">
    <script>


        layui.use(['form', 'layedit', 'laydate'], function () {
            var form = layui.form
                , layer = layui.layer
                , layedit = layui.layedit
                , laydate = layui.laydate;


            //上传图片,必须放在 创建一个编辑器前面
            layedit.set({
                uploadImage: {
                    url: '/admin/upload/img' //接口url
                    , type: 'post' //默认post
                }
            });

            //创建一个编辑器
            var editIndex = layedit.build('content', {
                    height: 350,
                }
            );

            layui.code({
                elem: 'pre', //默认值为.layui-code
            });

            //自定义验证规则
            form.verify({
                title: function (value) {
                    if (value.length < 2) {
                        return '标题至少得2个字符啊';
                    }
                },
                key: [/^[a-zA-Z_-]{2,20}$/, '别名输入不规范'],
                content: function (value) {
                    layedit.sync(editIndex);
                }
            });
            layedit.build('content', {
                tool: [
                    'strong' //加粗
                    , 'italic' //斜体
                    , 'underline' //下划线
                    , 'del' //删除线

                    , '|' //分割线

                    , 'left' //左对齐
                    , 'center' //居中对齐
                    , 'right' //右对齐
                    , 'link' //超链接
                    , 'unlink' //清除链接
                    , 'face' //表情
                    , 'image' //插入图片
                    , 'code'
                ]
            });

            // 点击按钮应用样式
            $('#applyStyle').click(function () {
                var style = $('#styleSelect').val();
                if (style === 'h1') {
                    layedit.insertHTML(index, '<h1>标题</h1>');
                } else if (style === 'h2') {
                    layedit.insertHTML(index, '<h2>标题</h2>');
                } else if (style === 'code') {
                    layedit.insertHTML(index, '<pre><code>// 代码块</code></pre>');
                } else {
                    layedit.insertHTML(index, '<p>正文</p>');
                }
            });

        })
    </script>

</rapid:override>


<%--此句必须放在最后--%>
<%@ include file="../Public/framework.jsp" %>

