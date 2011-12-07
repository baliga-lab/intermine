package org.intermine.webservice.server.output;

/*
 * Copyright (C) 2002-2011 FlyMine
 *
 * This code may be freely distributed and modified under the
 * terms of the GNU Lesser General Public Licence.  This should
 * be distributed with the code.  See the LICENSE file for more
 * information or http://www.gnu.org/copyleft/lesser.html.
 *
 */

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.StringEscapeUtils;

import org.intermine.api.InterMineAPI;
import org.intermine.api.results.ExportResultsIterator;
import org.intermine.api.results.ResultElement;
import org.intermine.model.InterMineObject;
import org.intermine.pathquery.Path;
import org.intermine.web.logic.PortalHelper;
import org.json.JSONArray;
import org.json.JSONObject;

/**
 * @author Alexis Kalderimis
 *
 */
public class JSONRowIterator implements Iterator<JSONArray>
{

    private final ExportResultsIterator subIter;
    private final List<Path> viewPaths = new ArrayList<Path>();
    private final InterMineAPI im;

    private static final String CELL_KEY_URL = "url";
    private static final String CELL_KEY_VALUE = "value";
    private static final String CELL_KEY_CLASS = "class";
    private static final String CELL_KEY_ID = "id";

    /**
     * Constructor
     * @param it An ExportResultsIterator that will be used internally to process the data.
     * @param im A reference to the the API settings bundle.
     */
    public JSONRowIterator(ExportResultsIterator it, InterMineAPI im) {
        this.subIter = it;
        this.im = im;
        init();
    }

    private void init() {
        viewPaths.addAll(subIter.getViewPaths());
    }

    @Override
    public boolean hasNext() {
        return subIter.hasNext();
    }

    /**
     * Get the JSONObject that represents each cell in the results row
     * @param cell The result element with the data
     * @return A JSONObject
     */
    protected JSONObject makeCell(ResultElement cell) {
        Map<String, Object> mapping = new HashMap<String, Object>();
        if (cell == null || cell.getId() == null) {
            mapping.put(CELL_KEY_URL, null);
            mapping.put(CELL_KEY_VALUE, null);
        } else {
            String link = null;
            if (im.getLinkRedirector() != null) {
                link = im.getLinkRedirector().generateLink(im, (InterMineObject) cell.getObject());
            }
            if (link == null) {
                link = PortalHelper.generateReportPath(cell);
            }
            mapping.put(CELL_KEY_URL, link);
            mapping.put(CELL_KEY_CLASS, cell.getType());
            mapping.put(CELL_KEY_ID, cell.getId());
            mapping.put(CELL_KEY_VALUE, cell.getField());
        }
        JSONObject ret = new JSONObject(mapping);
        return ret;
    }

    @Override
    public JSONArray next() {
        List<ResultElement> row = subIter.next();
        List<Object> jsonRow = new ArrayList<Object>();
        for (int i = 0; i < row.size(); i++) {
            ResultElement re = row.get(i);
            jsonRow.add(makeCell(re));
        }
        JSONArray next = new JSONArray(jsonRow);
        return next;
    }

    @Override
    public void remove() {
        throw new UnsupportedOperationException("Remove is not supported for this implementation");
    }

}
