<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ page session="true"%>
<c:set var="loginId" value="${sessionScope.id}"/>
<c:set var="loginOutLink" value="${loginId=='' ? '/login/login' : '/login/logout'}"/>
<c:set var="loginOut" value="${loginId=='' ? 'Login' : 'ID='+=loginId}"/>
<!DOCTYPE html>
<html>
<head>
    <jsp:include page="/WEB-INF/views/common/header.jsp"/>

    <style>


    a {
        text-decoration: none;
        color: black;
    }
    button,
    input {
        border: none;
        outline: none;
    }

    .board-container {
        width: 60%;
        height: 600px;
        margin: 0 auto;
        /* border: 1px solid black; */
    }
    .search-container {
        background-color: #dee2e6;
        width: 100%;
        height: 100px; /* 높이를 조절 */
        border: 1px solid #ddd;
        margin-top: 10px;
        margin-bottom: 30px;
        display: flex;
        justify-content: center;
        align-items: center;
    }

    .search-form {
        height: 30px;
        display: flex;
        align-items: center; /* 수직 가운데 정렬 추가 */
    }

    .search-option {
        height: 45px;
        border: 1px solid #ccc;
    }

    .search-input {
        color: gray;
        background-color: white;
        border: 1px solid #ccc;
        height: 33px;
        width: 400px;
        font-size: 15px;
        padding: 5px 7px;
    }

    .search-input::placeholder {
        color: gray;
    }

    .search-button {
        width: 60px; /* 버튼 너비 조절 */
        height: 45px;
        background-color: rgb(22, 22, 22);
        color: rgb(209, 209, 209);
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 15px;
        cursor: pointer;
    }

    .search-button:hover {
        color: rgb(165, 165, 165);
    }

    table {
        border-collapse: collapse;
        width: 100%;
        border-top: 2px solid rgb(39, 39, 39);
    }

    tr:nth-child(even) {
        background-color: #f0f0f070;
    }

    th,
    td {
        width:300px;
        text-align: center;
        padding: 10px 12px;
        border-bottom: 1px solid #ddd;
    }

    th{
        background-color : #687BA6;
    }
    td {
        background-color:white;
    }

    .no      { width:150px;}
    .title   { width:50%;  }

    td.title   { text-align: center;  }
    td.writer  { text-align: center;  }
    td.viewcnt { text-align: center; }

    td.title:hover {
        text-decoration: underline;
    }

    .paging {
        color: black;
        width: 100%;
        align-items: center;
    }

    .page {
        color: black;
        padding: 6px;
        margin-right: 10px;
    }
    .paging-active {
        background-color: rgb(216, 216, 216);
        border-radius: 5px;
        color: rgb(24, 24, 24);
    }

    .paging-container {
        width:100%;
        height: 70px;
        display: flex;
        margin-top: 50px;
        margin : auto;
    }
    .btn-write {
        background-color: #2980b9; /* Blue background */
        height: 45px;
        border: none; /* Remove borders */
        color: black ; /* White text */
        padding: 6px 12px; /* Some padding */
        font-size: 16px ; /* Set a font size */
        cursor: pointer; /* Mouse pointer on hover */
        border-radius: 5px;
        margin-left: 30px;
        font-weight: bold;
    }

    .btn-write:hover {
        text-decoration: underline;


    }
    .notice-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 20px;
        background-color: #fff; /* 헤더 배경색을 흰색으로 설정 */
        border-bottom: 1px solid #e1e1e1;
        margin-bottom: 20px;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05); /* 헤더에 그림자 추가 */
    }
</style>
<script src="https://code.jquery.com/jquery-1.11.3.js"></script>
</head>

<meta charset="UTF-8">


<body>
<div class="notice-header">
    <h2>게시판</h2>

</div>

<script>
    let msg = "${msg}";
    if(msg=="LIST_ERR")  alert("게시물 목록을 가져오는데 실패했습니다. 다시 시도해 주세요.");
    if(msg=="READ_ERR")  alert("삭제되었거나 없는 게시물입니다.");
    if(msg=="DEL_ERR")   alert("삭제되었거나 없는 게시물입니다.");

    if(msg=="DEL_OK")    alert("성공적으로 삭제되었습니다.");
    if(msg=="WRT_OK")    alert("성공적으로 등록되었습니다.");
    if(msg=="MOD_OK")    alert("성공적으로 수정되었습니다.");
</script>
<div style="text-align:center">
    <div class="board-container">
        <div class="search-container">
            <form action="<c:url value="/board/list"/>" class="search-form" method="get">
                <select class="search-option" name="option">
                    <option value="A" ${ph.sc.option=='A' || ph.sc.option=='' ? "selected" : ""}>제목+내용</option>
                    <option value="T" ${ph.sc.option=='T' ? "selected" : ""}>제목만</option>
                    <option value="W" ${ph.sc.option=='W' ? "selected" : ""}>작성자</option>
                </select>

                <input type="text" name="keyword" class="search-input" type="text" value="${ph.sc.keyword}" placeholder="검색어를 입력해주세요">
                <input type="submit" class="search-button" value="검색">
            </form>
            <button id="writeBtn" class="btn-write" onclick="location.href='<c:url value="/board/write"/>'"><i class="fa fa-pencil"></i> 글쓰기</button>
        </div>

        <table>
            <tr>
                <th class="no">번호</th>
                <th class="title">제목</th>
                <th class="writer">이름</th>
                <th class="regdate">등록일</th>
                <th class="viewcnt">조회수</th>
            </tr>
            <c:forEach var="boardDto" items="${list}">
                <tr>
                    <td class="no">${boardDto.bno}</td>
                    <td class="title"><a href="<c:url value="/board/read${ph.sc.queryString}&bno=${boardDto.bno}"/>">${boardDto.title}</a></td>
                    <td class="writer">${boardDto.writer}</td>
                    <c:choose>
                        <c:when test="${boardDto.reg_date.time >= startOfToday}">
                            <td class="regdate"><fmt:formatDate value="${boardDto.reg_date}" pattern="HH:mm" type="time"/></td>
                        </c:when>
                        <c:otherwise>
                            <td class="regdate"><fmt:formatDate value="${boardDto.reg_date}" pattern="yyyy-MM-dd" type="date"/></td>
                        </c:otherwise>
                    </c:choose>
                    <td class="viewcnt">${boardDto.view_cnt}</td>
                </tr>
            </c:forEach>
        </table>
        <br>
        <div class="paging-container">
            <div class="paging">
                <c:if test="${ph.totalCnt==null || ph.totalCnt==0}">
                    <div> 게시물이 없습니다. </div>
                </c:if>
                <c:if test="${ph.totalCnt!=null && ph.totalCnt!=0}">
                    <c:if test="${ph.showPrev}">
                        <a class="page" href="<c:url value="/board/list${ph.sc.getQueryString(ph.beginPage-1)}"/>">&lt;</a>
                    </c:if>
                    <c:forEach var="i" begin="${ph.beginPage}" end="${ph.endPage}">
                        <a class="page ${i==ph.sc.page? "paging-active" : ""}" href="<c:url value="/board/list${ph.sc.getQueryString(i)}"/>">${i}</a>
                    </c:forEach>
                    <c:if test="${ph.showNext}">
                        <a class="page" href="<c:url value="/board/list${ph.sc.getQueryString(ph.endPage+1)}"/>">&gt;</a>
                    </c:if>
                </c:if>
            </div>
        </div>
    </div>
</div>
</body>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
</html>