<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="im"%>

<!-- objectDetails.jsp -->
<html:xhtml/>

<c:set var="helpUrl"
       value="${WEB_PROPERTIES['project.helpLocation']}/manual/manualObjectDetails.html"/>

<%-- figure out whether we should show templates or not --%>
<c:set var="showTemplatesFlag" value="false"/>
<c:set var="showImportantTemplatesFlag" value="false"/>

<c:forEach items="${object.clds}" var="cld">
  <c:set var="className" value="${cld.name}"/>
  <c:if test="${!empty CLASS_CATEGORY_TEMPLATES[className]}">
    <c:set var="showTemplatesFlag" value="true"/>
    <c:forEach items="${CLASS_CATEGORY_TEMPLATES[className]}" var="cats">
      <c:forEach items="${cats.value}" var="tmpl">
        <c:if test="${tmpl.important}">
          <c:set var="showImportantTemplatesFlag" value="true"/>
        </c:if>
      </c:forEach>
    </c:forEach>
  </c:if>
</c:forEach>

<im:box helpUrl="${helpUrl}"
        titleKey="objectDetails.heading.details">

<tiles:get name="objectTrail.tile"/>

<c:if test="${!empty object}">

  <table width="100%">
    <tr>
      <td valign="top" width="30%">

        <im:heading id="summary">
          Summary for selected
          <c:forEach items="${object.clds}" var="cld">
            ${cld.unqualifiedName}
          </c:forEach>
        </im:heading>

        <im:body id="summary">
          <table cellpadding="5" border="0" cellspacing="0" class="objSummary">
            <c:forEach items="${object.fieldExprs}" var="expr">
              <c:if test="${object.fieldConfigMap[expr].showInSummary}">
                <im:eval evalExpression="object.object.${expr}" evalVariable="outVal"/>
                <tr>
                  <td nowrap>
                    <b><span class="attributeField">${expr}</span></b>
                    <c:forEach items="${object.clds}" var="cld">
                      <im:typehelp type="${cld.unqualifiedName}.${expr}"/>
                    </c:forEach>
                  </td>
                  <td>
                    <c:choose>                      
                      <c:when test="${empty outVal}">
                        <%-- add a space so that IE renders the borders --%>
                        &nbsp
                      </c:when>
                      <c:otherwise>
                        <b><im:value>${outVal}</im:value></b>
                      </c:otherwise>
                    </c:choose>
                  </td>
                </tr>
              </c:if>
            </c:forEach>
          
            <c:forEach items="${object.attributes}" var="entry">
              <c:if test="${! object.fieldConfigMap[entry.key].showInSummary && !object.fieldConfigMap[entry.key].sectionOnRight}">
                <tr>
                  <td>
                    <span class="attributeField">${entry.key}</span>
                  </td>
                  <td>
                    <c:set var="maxLength" value="60"/>
                    <c:choose>
                      <c:when test="${entry.value.class.name ==
                                    'java.lang.String' && fn:length(entry.value) > maxLength
                                    && ! object.fieldConfigMap[entry.key].doNotTruncate}">
                        <im:value>
                          ${fn:substring(entry.value, 0, maxLength/2)}
                        </im:value>
                        <span class="value" style="white-space:nowrap">
                          ${fn:substring(entry.value, maxLength/2, maxLength)}
                          <html:link action="/getAttributeAsFile?object=${object.id}&amp;field=${entry.key}">
                            <fmt:message key="objectDetails.viewall"/>
                          </html:link>
                        </span>
                      </c:when>
                      <c:otherwise>
                        <span class="value">${entry.value}</span>
                      </c:otherwise>
                    </c:choose>
                    <%--<c:if test="${IS_SUPERUSER}">
                      &nbsp;
                      <c:set var="descriptor" value="${object.attributeDescriptors[entry.key]}"/>
                      <tiles:insert name="inlineTagEditor.tile">
                        <tiles:put name="taggable" beanName="descriptor"/>
                      </tiles:insert>
                    </c:if>--%>
                  </td>
                </tr>
              </c:if>
            </c:forEach>
          </table>
          
          <c:forEach items="${LEAF_DESCRIPTORS_MAP[object.object]}" var="cld2">
            <c:if test="${WEBCONFIG.types[cld2.name].tableDisplayer != null}">
              <c:set var="cld2" value="${cld2}" scope="request"/>
              <p><tiles:insert page="${WEBCONFIG.types[cld2.name].tableDisplayer.src}"/></p>
            </c:if>
          </c:forEach>
          
        </im:body>
      </td>
      
      <td valign="top" width="66%">
        
        <c:forEach items="${object.clds}" var="cld">
          <c:if test="${fn:length(WEBCONFIG.types[cld.name].longDisplayers) > 0}">
            <im:heading id="further">
              <span style="white-space:nowrap">Further information for this ${cld.unqualifiedName}</span>
            </im:heading>
            <im:vspacer height="3"/>
            <im:body id="further">
              <c:forEach items="${WEBCONFIG.types[cld.name].longDisplayers}" var="displayer">
                <c:set var="object_bak" value="${object}"/>
                <c:set var="object" value="${object.object}" scope="request"/>
                <c:set var="cld" value="${cld}" scope="request"/>
                <tiles:insert beanName="displayer" beanProperty="src"/><br/>
                <c:set var="object" value="${object_bak}" scope="request"/>
              </c:forEach>
            </im:body>
          </c:if>
        </c:forEach>
        
        <%-- show important templates here --%>
        <c:if test="${showImportantTemplatesFlag == 'true'}">
          <im:heading id="important">Interesting template queries</im:heading>
          <im:vspacer height="3"/>
          <im:body id="important">
            <c:forEach items="${CATEGORIES}" var="category">
                
                  <%--<div class="heading">${category}</div>--%>
                  <!--<c:set var="interMineObject" value="${object.object}"/>-->
                  <!--<div class="body">-->
                   <tiles:insert name="templateList.tile">
                     <tiles:put name="type" value="global"/>
                     <tiles:put name="aspect" value="${category}"/>
                     <tiles:put name="displayObject" beanName="object"/>
                     <tiles:put name="important" value="true"/>
                   </tiles:insert>
                  <!--</div>-->
                  <%--<im:vspacer height="5"/>--%>
            </c:forEach>
          </im:body>
          <im:vspacer height="6"/>
        </c:if>

      </td>

    </tr>
    <tr>

      <td valign="top" colspan="2" width="100%">

        <c:forEach items="${CATEGORIES}" var="category">
          <im:heading id="${category}">
            ${category}<%--<im:helplink key="objectDetails.help.otherInfo"/>--%>
          </im:heading>
          <im:body id="${category}">
            <tiles:insert page="/objectDetailsAspectRefsCols.jsp">
              <tiles:put name="object" beanName="object"/>
              <tiles:put name="aspect" value="${category}"/>
            </tiles:insert>
            <tiles:insert name="templateList.tile">
              <tiles:put name="type" value="global"/>
              <tiles:put name="aspect" value="${category}"/>
              <tiles:put name="displayObject" beanName="object"/>
              <tiles:put name="noTemplatesMsgKey" value="templateList.noTemplates"/>
            </tiles:insert>
            <im:vspacer height="5"/>
          </im:body>
        </c:forEach>
        <im:heading id="Misc">
          Miscellaneous
        </im:heading>
        <im:body id="${category}">
          <tiles:insert page="/objectDetailsAspectRefsCols.jsp">
            <tiles:put name="object" beanName="object"/>
            <tiles:put name="aspect" value="Miscellaneous"/>
          </tiles:insert>
        </im:body>
        
        <c:forEach items="${object.attributes}" var="entry">
          <c:if test="${object.fieldConfigMap[entry.key].sectionOnRight}">
          	<im:heading id="right-${entry.key}">
          	  ${object.fieldConfigMap[entry.key].sectionTitle}
          	</im:heading>
          	<im:body id="right-${entry.key}">
          	
        	    <c:set var="maxLength" value="80"/>
              <c:choose>
                <c:when test="${entry.value.class.name ==
                              'java.lang.String' && fn:length(entry.value) > maxLength
                              && ! object.fieldConfigMap[entry.key].doNotTruncate}">
                  <span class="value">
                    ${fn:substring(entry.value, 0, maxLength/2)}
                  </span>
                  <span class="value" style="white-space:nowrap">
                    ${fn:substring(entry.value, maxLength/2, maxLength)}
                    <html:link action="/getAttributeAsFile?object=${object.id}&amp;field=${entry.key}">
                      <fmt:message key="objectDetails.viewall"/>
                    </html:link>
                  </span>
                </c:when>
                <c:otherwise>
                  <span class="value">${entry.value}</span>
                </c:otherwise>
              </c:choose>
              
          	</im:body>
          </c:if>
        </c:forEach>    
        
      </td>

    </tr>
  </table>

</c:if>

<div class="body">
  <c:if test="${!empty PROFILE.savedBags}">
    <form action="<html:rewrite page="/addToBagAction.do"/>" method="POST">
      <fmt:message key="objectDetails.addToBag"/>
      <input type="hidden" name="__intermine_forward_params__" value="${pageContext.request.queryString}"/>
      <select name="bag">
        <c:forEach items="${PROFILE.savedBags}" var="entry">
          <option name="${entry.key}">${entry.key}</option>
        </c:forEach>
      </select>
      <input type="hidden" name="object" value="${object.id}"/>
      <input type="submit" value="<fmt:message key="button.add"/>"/>
    </form>
  </c:if>
</div>

<c:if test="${empty object}">
  <%-- Display message if object not found --%>
  <div class="altmessage">
    <fmt:message key="objectDetails.noSuchObject"/>
  </div>
</c:if>

</im:box>

<!-- /objectDetails.jsp -->
