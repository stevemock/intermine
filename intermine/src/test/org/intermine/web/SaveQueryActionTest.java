package org.flymine.web;

/*
 * Copyright (C) 2002-2003 FlyMine
 *
 * This code may be freely distributed and modified under the
 * terms of the GNU Lesser General Public Licence.  This should
 * be distributed with the code.  See the LICENSE file for more
 * information or http://www.gnu.org/copyleft/lesser.html.
 *
 */

import servletunit.struts.MockStrutsTestCase;

import javax.servlet.http.HttpSession;
import java.util.Map;
import java.util.HashMap;
import java.util.IdentityHashMap;

import org.flymine.objectstore.query.Query;
import org.flymine.objectstore.query.QueryClass;
import org.flymine.objectstore.query.ConstraintOp;
import org.flymine.metadata.Model;
import org.flymine.metadata.ClassDescriptor;
import org.flymine.metadata.presentation.DisplayModel;
import org.flymine.model.testmodel.Company;
import org.flymine.model.testmodel.Employee;
import org.flymine.web.SaveQueryController;

public class SaveQueryActionTest extends MockStrutsTestCase
{
    Map savedQueries = new HashMap();
    Map savedQueriesInverse = new IdentityHashMap();

    public SaveQueryActionTest (String testName) {
        super(testName);
    }

    public void setUp() throws Exception {
        super.setUp();

        Query q1 = new Query();
        Query q2 = new Query();
        QueryClass qc1 = new QueryClass(Company.class);
        QueryClass qc2 = new QueryClass(Employee.class);
        q1.addFrom(qc1);
        q2.addFrom(qc1);
        q2.addFrom(qc2);

        savedQueries.put("query1", q1);
        savedQueries.put("query2", q2);
        savedQueriesInverse.put(q1, "query1");
        savedQueriesInverse.put(q2, "query2");
    }

    /**
     * Test saving a query when there are no saved queries.
     */
    public void testSuccessfulNoSavedQueries() throws Exception {
        setRequestPathInfo("/saveQuery");
        HttpSession session = getRequest().getSession();
        addRequestParameter("action", "Save a query");

        session.setAttribute(SaveQueryController.SAVEDQUERIES_NAME, new HashMap());
        session.setAttribute(SaveQueryController.SAVEDQUERIESINVERSE_NAME, new IdentityHashMap());
        session.setAttribute("query", new Query());
        session.setAttribute("queryClass", new QueryClass(Employee.class));
        session.setAttribute("constraints", "constraints");
        session.setAttribute("ops", "ops");

        SaveQueryForm form = new SaveQueryForm();
        form.setQueryName("query1");
        setActionForm(form);

        actionPerform();
        verifyForward("buildquery");
        verifyNoActionErrors();
        assertNull(session.getAttribute("query"));
        assertNull(session.getAttribute("queryClass"));
        assertNull(session.getAttribute("constraints"));
        assertNull(session.getAttribute("ops"));
        assertEquals(1, ((Map)session.getAttribute(SaveQueryController.SAVEDQUERIES_NAME)).size());
    }

    /**
     * Test saving a query when there are saved queries.
     */
    public void testSuccessfulSavedQueries() throws Exception {
        setRequestPathInfo("/saveQuery");
        HttpSession session = getRequest().getSession();
        addRequestParameter("action", "Save a query");

        session.setAttribute(SaveQueryController.SAVEDQUERIES_NAME,
                             new HashMap(savedQueries));
        session.setAttribute(SaveQueryController.SAVEDQUERIESINVERSE_NAME,
                             new IdentityHashMap(savedQueriesInverse));
        session.setAttribute("query", new Query());
        session.setAttribute("queryClass", new QueryClass(Employee.class));
        session.setAttribute("constraints", "constraints");
        session.setAttribute("ops", "ops");

        SaveQueryForm form = new SaveQueryForm();
        form.setQueryName("query3");
        setActionForm(form);

        actionPerform();
        verifyForward("buildquery");
        verifyNoActionErrors();
        assertNull(session.getAttribute("query"));
        assertNull(session.getAttribute("queryClass"));
        assertNull(session.getAttribute("constraints"));
        assertNull(session.getAttribute("ops"));
        Map savedQueriesFromSession =
            (Map)session.getAttribute(SaveQueryController.SAVEDQUERIES_NAME);
        assertEquals(3, savedQueriesFromSession.size());
        assertNotNull(savedQueriesFromSession.get("query1"));
        assertNotNull(savedQueriesFromSession.get("query2"));
        assertNotNull(savedQueriesFromSession.get("query3"));
    }

    /**
     * Test saving a query when there are saved queries are a name clash -
     * the new queryName is the same as an existing one.
     */
    public void testSuccessfulSavedQueriesNameClash() throws Exception {
        setRequestPathInfo("/saveQuery");
        HttpSession session = getRequest().getSession();
        addRequestParameter("action", "Save a query");

        session.setAttribute(SaveQueryController.SAVEDQUERIES_NAME,
                             new HashMap(savedQueries));
        session.setAttribute(SaveQueryController.SAVEDQUERIESINVERSE_NAME,
                             new IdentityHashMap(savedQueriesInverse));
        session.setAttribute("query", new Query());
        session.setAttribute("queryClass", new QueryClass(Employee.class));
        session.setAttribute("constraints", "constraints");
        session.setAttribute("ops", "ops");

        SaveQueryForm form = new SaveQueryForm();
        form.setQueryName("query2");
        setActionForm(form);

        actionPerform();
        verifyForward("buildquery");
        verifyNoActionErrors();
        assertNull(session.getAttribute("query"));
        assertNull(session.getAttribute("queryClass"));
        assertNull(session.getAttribute("constraints"));
        assertNull(session.getAttribute("ops"));
        Map savedQueriesFromSession =
            (Map)session.getAttribute(SaveQueryController.SAVEDQUERIES_NAME);
        assertEquals(2, savedQueries.size ());
        assertEquals(2, savedQueriesFromSession.size());
        assertNotNull(savedQueriesFromSession.get("query1"));
        assertNotNull(savedQueriesFromSession.get("query2"));
    }
}
