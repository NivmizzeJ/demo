<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>机构添加</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
	
	<link rel="stylesheet" type="text/css" href="layui/css/layui.css" media="all">
	<link href="css/main.css" rel="stylesheet" type="text/css" />
	<link href="css/style.css" rel="stylesheet" type="text/css" />
	
	<script type="text/javascript" src="js/jquery.min.js"></script>
	<script type="text/javascript" src="layui/layui.js"></script>
	<script type="text/javascript" src="plugins/artDialog/artDialog.source.js"></script>
	<script type="text/javascript" src="plugins/artDialog/plugins/iframeTools.source.js"></script>
	<script type="text/javascript" src="js/validator.js"></script>
	<script type="text/javascript" src="js/ui.js"></script>
	<script type="text/javascript" src="js/tableStyle.js"></script>
<script type="text/javascript">
$(function(){
	
	$("#addSto").click(function(){
	       layui.use(['layer'], function(){
		  var layer = layui.layer;
		  layer.open({
			  title: '信息',
			  type: 1,
	          skin: 'layui-layer-rim', //加上边框
	          area: ['250px', '300px'],
	 		  closeBtn: 1,
			  content: $('#info')
				});  
	 		});
		});
		
	$("#stoid").blur(function(){
		$.ajax({
			url: '${pageContext.request.contextPath}/storeController/queryStore.do',
			type: 'POST',
			data:{storeid:$("#stoid").val()},
			dataType: 'json',
			success: function (list) {
				if(list=='1'){
					layui.use(['layer'], function(){
						var layer = layui.layer;
						layer.open({content:"机构号已存在"});
						$("#btn").attr("disabled",true);
					});
				}else{
					$("#btn").attr("disabled",false);
				}
			}
		});
	})
	
	});
	
	//----------------------------------分页跳转----------------------------------//	 
	function goPage(){
	   var reg=/^[0-9]*$/;
		var page = document.getElementById("go").value;
		if(!reg.test(page)){
		   var page='${curPage}';
		   location.href="${pageContext.request.contextPath}/storeController/queryAllStore.do?page="+page;
		}else{
			location.href="${pageContext.request.contextPath}/storeController/queryAllStore.do?page="+page;
		}
	}
	
	//----------------------------------------修改机构信息-------------------------------------//	 
	function updateStore(storeid,storeName,linkMan,linkTel,state,address){
	    $("#ostoreid").val(storeid);
	    $("#ostoreName").val(storeName);
	    $("#olinkMan").val(linkMan);
	    $("#olinkTel").val(linkTel);
	    $("#ostate").val(state);
	    $("#oaddress").val(address);
		layui.use(['layer'], function(){
	   		var layer = layui.layer;
		   	layer.open({
				title:    '信息',
				type:     1,
	        	/* skin:     'layui-layer-rim', //加上边框 */
	     		area:     ['400px', '300px'],
	     		closeBtn: 1,
	     		shadeClose: true,
				content:  $('#uStore')
			}); 
		}); 
	 }
	
	//-------------------------------------------文本框验证---------------------------//
	function checkSubmit(id) {
		var stoid = document.getElementById("stoid");
		var stoName = document.getElementById("stoName");
		if (trim(stoid.value).length == 0 || stoid.value == "") {
			layui.use(['layer'], function(){
				   var layer = layui.layer;
				     layer.open({content:"机构号不能为空"});
				   });
			return false;
		}
		if (trim(stoName.value).length == 0 || stoName.value == "") {
			layui.use(['layer'], function(){
				   var layer = layui.layer;
				     layer.open({content:"机构名称不能为空"});
				   });
			return false;
		}
		return true;
	}
	
	//---------------------关闭弹窗-----------------------//	 
	function onClose(){
		layui.use(['layer'], function(){
	 		var layer = layui.layer;
		    	layer.closeAll();
		});
	}
	
</script>
<style type="text/css">
	#td{
	text-align: center;
	}
	#go{
	width: 30px;
	height: 20px;
	}
	#form{
	 text-align: center;
	}
	div, ul, ol, li, form, fieldset, table, p {
	font: 12px/23px 宋体;
	}
	.do{
	color:blue;
	}
	.layui-input{
	width: 80px;
	height: 15px;
	}
	.lim{
	width: 100px;
	height: 18px;
	}
	.inp{
	margin-left:12px;
	float: left;
	}
	#cho{
	margin-left: 10px;
	padding-top: 5px;
	}
</style>
</head>
  
<body>
	<div style="height: 35px;background-color:#efefef;">
		<div id="cho">
			<button class="layui-btn layui-btn-mini" id="addSto" type="button">添加</button>
		</div>
	</div>
   
	<c:choose>
	<c:when test="${not empty list}">
		<div style="margin-top: 20px;margin-left:15px;margin-right:15px">
			<center style="overflow:auto;">
				<table id="table1" cellpadding="0" cellspacing="0" border="1px" bordercolor="#efefef" width="100%">
					<tr>
						<th>序号</th>
						<th>机构号</th>
						<th>机构名称</th>
						<th>联系人</th>
						<th>联系电话</th>
						<th>状态</th>
						<th>机构地址</th>
						<th>备注</th>
						<th>操作</th>
					</tr>
					<c:forEach var="l" varStatus="s" items="${list}">
						<tr>
							<td id="td"  style="width:50px;">${s.index+1}</td>
							<td id="td" style="width:100px;">${l.storeId}</td>
							<td id="td" style="width:200px;">${l.storeName}</td>
							<td id="td" style="width:100px;">${l.linkMan}</td>
							<td id="td" style="width:100px;">${l.linkTel}</td>
							<c:if test="${l.state=='0'}">
								<td id="td" style="width:50px;">录入</td>
							</c:if>
							<c:if test="${l.state=='1'}">
								<td id="td" style="width:50px;">已激活</td>
							</c:if>
							<c:if test="${l.state=='2'}">
								<td id="td" style="width:50px;">已注销</td>
							</c:if>
							<td id="td" style="width:200px;">${l.address}</td>
							<td id="td"></td>
							<td id="td"  style="width:100px;">
								<a onclick="updateStore('${l.storeId}','${l.storeName}','${l.linkMan}','${l.linkTel}','${l.state}','${l.address}');" style="color:blue">修改</a>
								|
								<c:if test="${l.state!='2'}">
									<a href="${pageContext.request.contextPath}/storeController/logout.do?storeid=${l.storeId}" style="color:blue">注销</a>
								</c:if>
								<c:if test="${l.state=='2'}">
									已注销
								</c:if>
							</td>
						</tr>
					</c:forEach>
				</table>
			</center>
			<center>
				<div id="demo4">
					<a href="${pageContext.request.contextPath }/storeController/queryAllStore.do?page=1">首页</a>
					<a href="${pageContext.request.contextPath }/storeController/queryAllStore.do?page=${curPage-1}">上一页</a>
					${curPage }/${totalpage }
					<a href="${pageContext.request.contextPath }/storeController/queryAllStore.do?page=${curPage+1}">下一页</a>
					<a href="${pageContext.request.contextPath }/storeController/queryAllStore.do?page=${totalpage}">尾页</a>
					<input type="text" id="go" /> <input type="button" value="跳转" onclick="goPage()" />
				</div>
				<span>共${count}条记录</span>
			</center>
		</div>
	</c:when>
	<c:otherwise>
		<center>
		<div style="margin-top: 20px;margin-left:15px;margin-right:15px">
			<table cellpadding="0" cellspacing="0" border="1px"
					bordercolor="#efefef" width="100%">
					<tr>
						<th>序号</th>
						<th>机构号</th>
						<th>机构名称</th>
						<th>联系人</th>
						<th>联系电话</th>
						<th>机构地址</th>
						<th>备注</th>
					</tr>
				</table>
				尚未有相关记录
			</div>
		</center>
	</c:otherwise>
	</c:choose>
	
	
	<!-- 添加商户信息弹框 -->
	<div id="info" style="display: none;">
		<form action="${pageContext.request.contextPath}/storeController/addStore.do" method="post">
			<div class="dialogTop">
			  	<table style="margin-top:10;" border="0" align="center">
			        <tr>
			          <td align="right">机构号：</td>
			          <td>
			          	<input type="text"  class="ldText" name="storeid" id="stoid" maxlength="11" style="width:140px;"/>
			          </td>
		          	</tr>
		          	<tr>
			          <td align="right">机构名称：</td>
			          <td>
			          	<input type="text"  class="ldText" name="storeName" id="stoName" maxlength="20" style="width:140px;margin-top:5px"/>
			          </td>
		          	</tr>
		          	<tr>
			          <td align="right">联系人：</td>
			          <td>
			          	<input type="text"  class="ldText" name="linkMan" maxlength="10" style="width:140px;margin-top:5px"/>
			          </td>
		          	</tr>
		          	<tr>
			          <td align="right">联系电话：</td>
			          <td>
			          	<input type="text"  class="ldText" name="linkTel" maxlength="11" style="width:140px;margin-top:5px"/>
			          </td>
		          	</tr>
		          	<tr>
			          <td align="right">机构地址：</td>
			          <td>
			          	<input type="text"  class="ldText" name="address" maxlength="20" style="width:140px;margin-top:5px"/>
			          </td>
		          	</tr>
			   </table>
	   		</div>
		   	<div class="dialogBottom">
		   		<div class="btns">
			   		<input type="submit" class="ldBtnGreen" id="btn" value="确定" onclick="return checkSubmit();"/>
			   		<input type="button" value="关闭" class="ldBtnGray" onclick="onClose();">
			    </div>
			</div>
	  </form>
	</div>
	
	<!-- 修改机构信息弹框 -->
	<div id="uStore" style="display: none;">
		<form action="${pageContext.request.contextPath}/storeController/updateStore.do" method="post">
			<div class="dialogTop">
			  	<table style="margin-top:10;" border="0" align="center">
			        <tr>
			          <td align="right">机构号：</td>
			          <td>
			          	<input type="text"  class="ldText" name="storeid" id="ostoreid" maxlength="11" style="width:140px;background-color: lightgray;" readonly="readonly"/>
			          </td>
		          	</tr>
		          	<tr>
			          <td align="right">机构名称：</td>
			          <td>
			          	<input type="text"  class="ldText" name="storeName" id="ostoreName" maxlength="20" style="width:140px;margin-top:5px"/>
			          </td>
		          	</tr>
		          	<tr>
			          <td align="right">联系人：</td>
			          <td>
			          	<input type="text"  class="ldText" name="linkMan" id="olinkMan" maxlength="10" style="width:140px;margin-top:5px"/>
			          </td>
		          	</tr>
		          	<tr>
			          <td align="right">联系电话：</td>
			          <td>
			          	<input type="text"  class="ldText" name="linkTel" id="olinkTel" maxlength="11" style="width:140px;margin-top:5px"/>
			          </td>
		          	</tr>
		          	<tr>
			          <td align="right">机构地址：</td>
			          <td>
			          	<input type="text"  class="ldText" name="address" id="oaddress" maxlength="20" style="width:140px;margin-top:5px"/>
			          </td>
		          	</tr>
		          	<tr>
		          	<td align="right">机构状态：</td>
		          	 <td>
			           <select class="ldSelect" name="state" id="ostate" style="width:140px;height:24px;margin-top:5px">
			          	  <option disabled="disabled" value="">---请选择---</option>
				          <option value="0">录入</option>
				          <option value="1">已激活</option>
				          <option value="2">已撤销</option>
				        </select>
			         </td>
		          	</tr>
			   </table>
	   		</div>
		   	<div class="dialogBottom">
		   		<div class="btns">
			   		<input type="submit" class="ldBtnGreen" id="btn" value="确定"/>
			   		<input type="button" value="关闭" class="ldBtnGray" onclick="onClose();">
			    </div>
			</div>
	  </form>
	</div>
</body>
</html>
