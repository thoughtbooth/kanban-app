<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<%@page import="com.metservice.kanban.model.WorkItem"%>
<%@page import="java.util.List"%>
<%@page import="com.metservice.kanban.model.TreeNode"%>
<%@page import="com.metservice.kanban.model.KanbanProject"%>
<%@page import="com.metservice.kanban.KanbanService"%>
<%@page import="java.util.Collection"%>
<%@page import="com.metservice.kanban.model.WorkItemTree"%>
<%@page import="com.metservice.kanban.model.KanbanProjectConfiguration"%>
<%@page import="com.metservice.kanban.model.KanbanProjectConfigurationBuilder"%>
<%@page import="com.metservice.kanban.model.WorkItemType"%>
<%@page import="com.metservice.kanban.model.WorkItemTypeCollection"%>


<%
KanbanProject project = (KanbanProject) request.getAttribute("project");
String boardType = (String) request.getAttribute("board");
WorkItemTypeCollection workItemTypes = project.getWorkItemTypes();
TreeNode<WorkItemType> topLevel = workItemTypes.getRoot();
WorkItemType secondLevel = null;
if (topLevel.hasChildren()) {
	secondLevel = topLevel.getChild(0).getValue();
}
 
String currentProjectName = (String) request.getAttribute("projectName");
KanbanService service = new KanbanService();
request.setAttribute("service", service);
request.setAttribute("secondLevel", secondLevel);
request.setAttribute("workItemTypes", workItemTypes);
%>
<script type="text/javascript">
    $(document).ready(function(){
        $("#graphs").click(function(){
            $("#graph_dropdown").fadeToggle();
            $("#graphs").toggleClass("active");
        });
    });
</script>

<form id="header" method="post" action="">
    <div class="header">
        <div class="user-home">${service.home.absolutePath}</div>
        <div class="version">VERSION: ${service.version}</div>
        <div id="projectDropdown">
    		<label class="projectPicker" for="projectPicker">Project:</label>
			<select id="projectPicker" onchange="changeProject('projectPicker')">
					<c:forEach var="projectName" items="${service.projects}">
				        <option <c:if test="${projectName == project.name}">selected</c:if>>${projectName}</option>
					</c:forEach>
			</select>        
        </div>
<%--         <div id="add-top-level-item-button" class="button" onclick="javascript:addTopLevel(<%= WorkItem.ROOT_WORK_ITEM_ID%>);" > --%>
<%--         	<div class ="textOnButton"><span style="font-weight:bold;font-size:120%;line-height:100%">+</span> Add ${project.workItemTypes.root.value}</div> --%>
<!--         </div> -->
        <div id="add-top-level-item-button" class="button">
        	<div class ="textOnButton">
        		<a href="${pageContext.request.contextPath}/projects/${project.name}/backlog/add-item?id=<%= WorkItem.ROOT_WORK_ITEM_ID%>" class="textOnButton">
        			<span style="font-weight:bold;font-size:120%;line-height:100%">+</span> Add ${project.workItemTypes.root.value}
        		</a>
        	</div>
        </div>
        <div id="backlog-button" class="button"><a href="${pageContext.request.contextPath}/projects/${project.name}/backlog" class="textOnButton">Backlog</a></div>
        <div id="wall" class="button"><a href="${pageContext.request.contextPath}/projects/${project.name}/wall" class="textOnButton">Wall</a></div>
        <div id="journal" class="button"><a href="${pageContext.request.contextPath}/projects/${project.name}/journal" class="textOnButton">Journal</a></div>
        <div id="complete" class="button"><a href="${pageContext.request.contextPath}/projects/${project.name}/completed" class="textOnButton">Complete</a></div>

        <c:if test="${boardType == 'wall' || boardType == 'backlog' }">
        <div id="print" class="button" onclick="javascript:printCards();" ><div class ="textOnButton">Print</div></div>
		</c:if>
      <!-- Start of graph menu -->
			
					<div id="graphs" class="button">
					  <div class ="textOnButton">
					    Graphs
					  </div>
          </div>	
          <div id="graph_dropdown">
            <a id="cumulative-flow-chart-1-button"  onclick="javascript:chart('cumulative-flow-chart','${project.workItemTypes.root.value.name}');return false;" >
              <img src="${pageContext.request.contextPath}/images/cumulative-flow-chart.png" />
	            ${project.workItemTypes.root.value.name}
	          </a>
			      
            <c:if test="${secondLevel != null}" >
              <a id="cumulative-flow-chart-2-button" onclick="javascript:
              chart('cumulative-flow-chart','${secondLevel.name}');return false;">
                <img src="${pageContext.request.contextPath}/images/cumulative-flow-chart.png" />${secondLevel.name}</a>
            </c:if>
           
              <a id="cycle-time-chart-1-button" onclick="javascript:
                chart('cycle-time-chart','${project.workItemTypes.root.value.name}');
                return false;">
                <img src="${pageContext.request.contextPath}/images/cycle-time-chart.png" />
                  ${project.workItemTypes.root.value.name}
              </a>
            
            <c:if test="${secondLevel != null}" >
              <a id="cycle-time-chart-2-button" onclick="javascript:
              chart('cycle-time-chart','${secondLevel.name}');return false;" >
              <img src="${pageContext.request.contextPath}/images/cycle-time-chart.png" />
                ${secondLevel.name}
              </a>
            </c:if>
          </div>			
			
			<!-- End of graph buttons -->
        <div id="burn-up-chart-button" class="button" onclick="javascript:chart('burn-up-chart','${project.workItemTypes.root.value.name}');" ><div class ="textOnButton">Burn-Up Chart</div></div>
        <div id="admin" class="button"><a href="${pageContext.request.contextPath}/projects/${project.name}/admin" class="textOnButton">Admin</a></div>
        <div id="pet" class="button"><a href="${pageContext.request.contextPath}/projects/${project.name}/pet-project" class="textOnButton">P.E.T.</a></div>
    </div>
</form>