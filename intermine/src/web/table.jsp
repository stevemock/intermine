<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="im" %>

<!-- table.jsp -->

<tiles:importAttribute/>
<html:xhtml/>

<c:if test="${!empty param.trail}">
  <tiles:get name="objectTrail.tile"/><im:vspacer height="3"/>
</c:if>

<script type="text/javascript">
  <!--//<![CDATA[
    function selectColumnCheckboxes(column) {
      var columnCheckBox = 'selectedObjects_' + column;
      with(document.saveBagForm) {
      for(i=0;i < elements.length;i++) {
        thiselm = elements[i];
        var testString = 'selectedObjects_' + column + '_';
        if(thiselm.id.indexOf(testString) != -1)
          thiselm.checked = document.getElementById(columnCheckBox).checked;
        }
      }
    }
    function unselectColumnCheckbox(column) {
      document.getElementById('selectedObjects_' + column).checked = false;
    }
    function changePageSize() {
      var url = '${requestScope['javax.servlet.include.context_path']}/results.do?';
      var pagesize = document.changeResultsSizeForm.pageSize.options[document.changeResultsSizeForm.pageSize.selectedIndex].value;
      var page = ${resultsTable.startRow}/pagesize;
      url += 'table=${param.table}' + '&page=' + Math.floor(page) + '&size=' + pagesize;
      if ('${param.trail}' != '')
      {
      	url += '&trail=${param.trail}';
      }
      document.location.href=url;
    }
    //]]>-->
</script>

<c:choose>
  <c:when test="${resultsTable.size == 0}">
    <div class="body">
      <fmt:message key="results.pageinfo.empty"/><br/>
    </div>
  </c:when>
  <c:otherwise>
  
    <html:form action="/changeResultsSize">
      <div class="body">
        <%-- Page size controls --%>
        <fmt:message key="results.changepagesize"/>
        <html:select property="pageSize" onchange="changePageSize()">
          <html:option value="10">10</html:option>
          <html:option value="25">25</html:option>
          <html:option value="50">50</html:option>
          <html:option value="100">100</html:option>
        </html:select>
        <input type="hidden" name="table" value="${param.table}"/>
        <input type="hidden" name="trail" value="${param.trail}"/>
        <noscript>
          <html:submit>
            <fmt:message key="button.change"/>
          </html:submit>
        </noscript>
      </div>
    </html:form>
    
    <div class="body">
      <p><tiles:insert page="/tablePageLinks.jsp"/></p>
    </div>
    
    <html:form action="/saveBag">
    <div class="body">

      <table class="results" cellspacing="0">
        
        <%-- The headers --%>
        <tr>
          <c:forEach var="column" items="${resultsTable.columns}" varStatus="status">
            <th align="center" rowspan="2">
              <html:multibox property="selectedObjects" styleId="selectedObjects_${status.index}"
                             onclick="selectColumnCheckboxes(${status.index})">
                <c:out value="${status.index}"/>
              </html:multibox>
            </th>

            <th align="center" valign="top" style="border-bottom: none">
              <div>
                <c:out value="${fn:replace(column.name, '.', ' > ')}"/>
              </div>
            </th>
          </c:forEach>
        </tr>

        <tr>
          <c:forEach var="column" items="${resultsTable.columns}" varStatus="status">
            <th align="center">
              <div style="white-space:nowrap">

                <%-- left --%>
                <c:choose>
                  <c:when test="${status.first}">
                    <img style="margin-right: 5px" border="0" align="middle" 
                         src="images/blank13x13.gif" alt=" " width="13" height="13"/>
                  </c:when>
                  <c:otherwise>
                    <fmt:message key="results.moveLeftHelp" var="moveLeftTitle">
                      <fmt:param value="${column.name}"/>
                    </fmt:message>
                    <fmt:message key="results.moveLeftSymbol" var="moveLeftString"/>
                    <html:link action="/changeResults?table=${param.table}&amp;method=moveColumnLeft&amp;index=${status.index}&amp;trail=${param.trail}"
                               title="${moveLeftTitle}">
                      <img style="margin-right: 5px" border="0" align="middle"
                           width="13" height="13" src="images/left-arrow-square.gif" 
                           alt="${moveRightString}"/>
                    </html:link>
                  </c:otherwise>
                </c:choose>

                <%-- show/hide --%>
                <c:choose>
                  <c:when test="${column.visible}">
                    <c:if test="${resultsTable.visibleColumnCount > 1}">
                      <fmt:message key="results.hideColumnHelp" var="hideColumnTitle">
                        <fmt:param value="${column.name}"/>
                      </fmt:message>
                      <html:link action="/changeResults?table=${param.table}&amp;method=hideColumn&amp;index=${status.index}&amp;trail=${param.trail}"
                                 title="${hideColumnTitle}">
                        <fmt:message key="results.hideColumn"/>
                      </html:link>
                    </c:if>
                  </c:when>
                  <c:otherwise>
                    <fmt:message key="results.showColumnHelp" var="showColumnTitle">
                      <fmt:param value="${column.name}"/>
                    </fmt:message>
                    <html:link action="/changeResults?table=${param.table}&amp;method=showColumn&amp;index=${status.index}&amp;trail=${param.trail}"
                               title="${showColumnTitle}">
                      <fmt:message key="results.showColumn"/>
                    </html:link>
                  </c:otherwise>
                </c:choose>

                <%-- right --%>
                <c:choose>
                  <c:when test="${status.last}">
                    <img style="margin-left: 5px" border="0" align="middle" 
                         src="images/blank13x13.gif" alt=" " width="13" height="13"/>
                  </c:when>
                  <c:otherwise>
                    <fmt:message key="results.moveRightHelp" var="moveRightTitle">
                      <fmt:param value="${column.name}"/>
                    </fmt:message>
                    <fmt:message key="results.moveRightSymbol" var="moveRightString"/>
                    <html:link action="/changeResults?table=${param.table}&amp;method=moveColumnRight&amp;index=${status.index}&amp;trail=${param.trail}"
                               title="${moveRightTitle}">
                      <img style="margin-left: 5px" border="0" align="middle" 
                           width="13" height="13"
                           src="images/right-arrow-square.gif" alt="${moveRightString}"/>
                    </html:link>
                  </c:otherwise>
                </c:choose>
              </div>
            </th>
          </c:forEach>
        </tr>

        <%-- The data --%>

        <%-- Row --%>
        <c:if test="${resultsTable.size > 0}">
          <c:forEach var="row" items="${resultsTable.rows}" varStatus="status">

            <c:set var="rowClass">
              <c:choose>
                <c:when test="${status.count % 2 == 1}">odd</c:when>
                <c:otherwise>even</c:otherwise>
              </c:choose>
            </c:set>

            <tr class="<c:out value="${rowClass}"/>">
              <c:forEach var="column" items="${resultsTable.columns}" varStatus="status2">
                <c:choose>
                  <c:when test="${column.visible}">
                    <%-- the checkbox to select this object --%>
                    <td align="center">
                      <html:multibox property="selectedObjects"
                                     styleId="selectedObjects_${status2.index}_${status.index}"
                                     onclick="unselectColumnCheckbox(${status2.index})">
                        <c:out value="${status2.index},${status.index}"/>
                      </html:multibox>
                    </td>
                    <td>
                      <c:set var="object" value="${row[column.index]}" scope="request"/>
                      <c:choose>
                        <c:when test="${resultsTable.summary}">
                          <c:set var="viewType" value="summary" scope="request"/>
                        </c:when>
                        <c:otherwise>
                          <c:set var="viewType" value="detail" scope="request"/>
                        </c:otherwise>
                      </c:choose>
                      <tiles:get name="objectView.tile" />
                    </td>
                  </c:when>
                  <c:otherwise>
                    <%-- add a space so that IE renders the borders --%>
                    <td colspan="2">&nbsp;</td>
                  </c:otherwise>
                </c:choose>
              </c:forEach>
            </tr>
          </c:forEach>
        </c:if>
      </table>

      <c:if test="${resultsTable.size > 1}">
        <%-- "Displaying xxx to xxx of xxx rows" messages --%>
        <br/>
        <c:choose>
          <c:when test="${resultsTable.sizeEstimate}">
            <fmt:message key="results.pageinfo.estimate">
              <fmt:param value="${resultsTable.startRow+1}"/>
              <fmt:param value="${resultsTable.endRow+1}"/>
              <fmt:param value="${resultsTable.size}"/>
            </fmt:message>
            <im:helplink key="results.help.estimate"/>
          </c:when>
          <c:otherwise>
            <fmt:message key="results.pageinfo.exact">
              <fmt:param value="${resultsTable.startRow+1}"/>
              <fmt:param value="${resultsTable.endRow+1}"/>
              <fmt:param value="${resultsTable.size}"/>
            </fmt:message>
          </c:otherwise>
        </c:choose>
        
        <%-- Paging controls --%>
        <p><tiles:insert page="/tablePageLinks.jsp"/></p>
      </c:if>

      <%-- Return to main results link --%>
      <c:if test="${resultsTable.class.name != 'org.intermine.web.results.PagedResults' && QUERY_RESULTS != null && !fn:startsWith(param.table, 'bag')}">
        <p>
          <html:link action="/results?table=results">
            <fmt:message key="results.return"/>
          </html:link>
        </p>
      </c:if>

      </div> <%-- end of main results table body div --%>
   
      <%-- Save bag controls --%>
      <c:if test="${resultsTable.size > 0}">
        <div class="heading">
          <fmt:message key="results.save"/><im:helplink key="results.help.save"/>
        </div>
        <div class="body">
          <ul>
            <li>
              <fmt:message key="bag.new"/>
              <html:text property="newBagName"/>
              <input type="hidden" name="__intermine_forward_params__" value="${pageContext.request.queryString}"/>
              <input type="hidden" name="table" value="${param.table}"/>
              <html:submit property="saveNewBag">
                <fmt:message key="button.save"/>
              </html:submit>
            </li>
            <c:if test="${!empty PROFILE.savedBags}">
              <li>
                <fmt:message key="bag.existing"/>
                <html:select property="existingBagName">
                  <c:forEach items="${PROFILE.savedBags}" var="entry">
                    <html:option value="${entry.key}"/>
                  </c:forEach>
                </html:select>
                <html:submit property="addToExistingBag">
                  <fmt:message key="button.add"/>
                </html:submit>
              </li>
            </c:if>
          </ul>
        </div>
      </c:if>
    </html:form>

    <tiles:get name="export.tile" />
  </c:otherwise>
</c:choose>
<!-- /table.jsp -->
