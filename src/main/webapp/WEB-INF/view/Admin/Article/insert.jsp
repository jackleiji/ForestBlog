<%--保留此处 start--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="rapid" uri="http://www.rapid-framework.org.cn/rapid" %>
<%--保留此处 end--%>
    <rapid:override name="title">
        - 新建文章
    </rapid:override>

<rapid:override name="content">
    <blockquote class="layui-elem-quote">
         <span class="layui-breadcrumb" lay-separator="/">
              <a href="/admin">首页</a>
              <a href="/admin/article">文章列表</a>
              <a><cite>添加文章</cite></a>
        </span>
    </blockquote>



    <form class="layui-form"  method="post" id="myForm" action="/admin/article/insertSubmit">

        <div class="layui-form-item">
            <label class="layui-form-label">标题 <span style="color: #FF5722; ">*</span></label>
            <div class="layui-input-block">
                <input type="text" name="articleTitle" lay-verify="title" id="title" autocomplete="off" placeholder="请输入标题" class="layui-input">
            </div>
        </div>

        <div class="layui-form-item layui-form-text">
            <label class="layui-form-label">内容 <span style="color: #FF5722; ">*</span></label>
            <div class="layui-input-block">
                <textarea class="layui-textarea" cols="30" rows="10"  name="articleContent" lay-verify="content" id="content"></textarea>
            </div>

        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">分类 <span style="color: #FF5722; ">*</span> </label>
            <div class="layui-input-inline">
                <select name="articleParentCategoryId" id="articleParentCategoryId" lay-filter="articleParentCategoryId" required>
                    <option value="" selected="">一级分类</option>
                    <c:forEach items="${categoryList}" var="c">
                        <c:if test="${c.categoryPid==0}">
                            <option value="${c.categoryId}">${c.categoryName}</option>
                        </c:if>
                    </c:forEach>
                </select>
            </div>
            <div class="layui-input-inline">
                <select name="articleChildCategoryId" id="articleChildCategoryId">
                    <option value="" selected>二级分类</option>
                </select>
            </div>
        </div>

        <div class="layui-form-item" pane="">
            <label class="layui-form-label">标签</label>
            <div class="layui-input-block">
                <c:forEach items="${tagList}" var="t">
                    <input type="checkbox" name="articleTagIds" lay-skin="primary" title="${t.tagName}" value="${t.tagId}">
                </c:forEach>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">缩略图</label>
            <div class="layui-input-inline">
                <div class="layui-upload">
                    <div class="layui-upload-list" style="">
                        <img class="layui-upload-img"  id="demo1" width="100"
                             height="100">
                        <p id="demoText"></p>
                    </div>
                    <button type="button" class="layui-btn" id="test1">上传图片</button>
                    <input type="hidden" name="articleThumbnail" id="articleThumbnail" >
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">状态</label>
            <div class="layui-input-block">
                <input type="radio" name="articleStatus" value="1" title="发布" checked>
                <input type="radio" name="articleStatus" value="0" title="草稿" >
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-input-block">
                <button class="layui-btn" lay-submit="" lay-filter="demo1">立即提交</button>
                <button type="reset" class="layui-btn layui-btn-primary">重置</button>
            </div>
        </div>
    </form>


</rapid:override>

<rapid:override name="footer-script">

    <script>
        //上传图片
        layui.use('upload', function () {
            var $ = layui.jquery,
                upload = layui.upload;
            var uploadInst = upload.render({
                elem: '#test1',
                url: '/admin/upload/img',
                before: function (obj) {
                    obj.preview(function (index, file, result) {
                        $('#demo1').attr('src', result);
                    });
                },
                done: function (res) {
                    $("#articleThumbnail").attr("value", res.data.src);
                    if (res.code > 0) {
                        return layer.msg('上传失败');
                    }
                },
                error: function () {
                    var demoText = $('#demoText');
                    demoText.html('' +
                        '<span style="color: #FF5722;">上传失败</span>' +
                        ' <a class="layui-btn layui-btn-mini demo-reload">重试</a>');
                    demoText.find('.demo-reload').on('click', function () {
                        uploadInst.upload();
                    });
                }
            });

        });
    </script>

    <script type="text/javascript" src="/plugin/layui/layui.js"></script>
    <script>
        /^http(s*):\/\//.test(location.href) || alert('请先部署到 localhost 下再访问');
        layui.extend({
            tinymce: '/plugin/layui/extend/tinymce/tinymce'
        }).use(['form', 'tinymce', 'util', 'layer'], function () {
            var form = layui.form
                ,tinymce = layui.tinymce
                , util = layui.util
                , layer = layui.layer
                , $ = layui.$

            var contentArea = tinymce.render({
                elem: "#content"
                , plugins : 'table,axupimgs,preview,textpattern,wordcount,textcolor quickbars  lists advlist, image, code, codesample' //字符串方式
                , toolbar : 'fontselect fontsizeselect bold formats forecolor backcolor italic underline strikethrough | alignleft aligncenter alignright alignjustify | formatselect preview table image codesample bullist numlist textpattern | code'
                , height: 600
                , min_height: 400
                // , images_upload_url: "/admin/upload/imgTinyMCE"
                // , images_upload_base_path: '/upload/'
                ,images_upload_handler: function (blobInfo, success, failure) {//关键代码
                    var form = new FormData();
                    console.log(blobInfo)
                    form.append('edit', blobInfo.blob(),  blobInfo.filename());
                    $.ajax({
                        url: "/admin/upload/imgTinyMCE" ,
                        type: "post",
                        data: form,
                        dataType: 'json',
                        processData: false,
                        contentType: false,
                        success: function (res) {
                            console.log(res);
                            var imgUrl =res.data.src;//根据返回值得不同这里要自己定义
                            console.log(imgUrl);
                            success(imgUrl);
                        },
                        error: function (e) {
                            alert("图片上传失败");
                        }
                    });

                }
                , init_instance_callback : function(ed) {
                    ed.on('KeyPress', function (e) {
                        console.log(e)
                    });
                }
            });
            //自定义验证规则
            form.verify({
                title: function (value) {
                    if (value.length < 5) {
                        return '标题至少得5个字符啊';
                    }
                }
                , pass: [/(.+){6,12}$/, '密码必须6到12位']
                , content: function (value) {
                    layedit.sync(editIndex);
                }
            });
            //二级联动
            form.on("select(articleParentCategoryId)",function () {
                var optionstring = "";
                var articleParentCategoryId = $("#articleParentCategoryId").val();
                <c:forEach items="${categoryList}" var="c">
                if(articleParentCategoryId==${c.categoryPid}) {
                    optionstring += "<option name='childCategory' value='${c.categoryId}'>${c.categoryName}</option>";
                }
                </c:forEach>
                $("#articleChildCategoryId").html("<option value=''selected>二级分类</option>"+optionstring);
                form.render('select'); //这个很重要
            })

        });
    </script>
</rapid:override>


<%--此句必须放在最后--%>
<%@ include file="../Public/framework.jsp"%>

