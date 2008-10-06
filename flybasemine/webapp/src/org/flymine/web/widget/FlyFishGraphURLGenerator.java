package org.flymine.web.widget;

/*
 * Copyright (C) 2002-2008 FlyMine
 *
 * This code may be freely distributed and modified under the
 * terms of the GNU Lesser General Public Licence.  This should
 * be distributed with the code.  See the LICENSE file for more
 * information or http://www.gnu.org/copyleft/lesser.html.
 *
 */

import org.intermine.metadata.Model;
import org.intermine.objectstore.ObjectStore;
import org.intermine.pathquery.Constraints;
import org.intermine.pathquery.PathQuery;
import org.intermine.web.logic.bag.InterMineBag;
import org.intermine.web.logic.widget.GraphCategoryURLGenerator;
import org.jfree.data.category.CategoryDataset;

/**
 *
 * @author Julie Sullivan
 *
 */
public class FlyFishGraphURLGenerator implements GraphCategoryURLGenerator
{
    String bagName;
    private static final  String DATASET = "fly-Fish data set";

    /**
     * Creates a FlyFishGraphURLGenerator for the chart
     * @param bagName the bag name
     * @param organism not used
     */
    public FlyFishGraphURLGenerator(String bagName, String organism) {
        super();
        this.bagName = bagName;
    }

    /**
     * Creates a FlyFishGraphURLGenerator for the chart
     * @param bagName the bag name
     */
    public FlyFishGraphURLGenerator(String bagName) {
        super();
        this.bagName = bagName;
    }


    /**
     * {@inheritDoc}
     * @see org.jfree.chart.urls.CategoryURLGenerator#generateURL(
     *      org.jfree.data.category.CategoryDataset,
     *      int, int)
     */
    public String generateURL(CategoryDataset dataset, int series, int category) {
        StringBuffer sb = new StringBuffer("queryForGraphAction.do?bagName=" + bagName);

        String seriesName = (String) dataset.getRowKey(series);
        seriesName = seriesName.toLowerCase();
        Boolean expressed = Boolean.FALSE;
        if (seriesName.equals("expressed")) {
            expressed = Boolean.TRUE;
        }

        sb = new StringBuffer("queryForGraphAction.do?bagName=" + bagName);
        sb.append("&category=" + dataset.getColumnKey(category));
        sb.append("&series=" + expressed);
        sb.append("&urlGen=org.flymine.web.widget.FlyFishGraphURLGenerator");

        return sb.toString();
    }

    /**
     * {@inheritDoc}
     */
    public PathQuery generatePathQuery(ObjectStore os,
                                       InterMineBag bag,
                                       String category,
                                       String series) {

        Model model = os.getModel();
        PathQuery q = new PathQuery(model);

        q.setView("Gene.primaryIdentifier, Gene.secondaryIdentifier, Gene.name, Gene.organism.name,"
                  + "Gene.mRNAExpressionResults.stageRange, Gene.mRNAExpressionResults.expressed");

        // bag constraint
        q.addConstraint("Gene",  Constraints.in(bag.getName()));

        // filter out BDGP
        q.addConstraint("Gene.mRNAExpressionResults.dataSet.title",  Constraints.eq(DATASET));

        // stage (category)
        q.addConstraint("Gene.mRNAExpressionResults.stageRange",
                        Constraints.eq(category + " (fly-FISH)"));

        // expressed (series)
        Boolean expressed = (series.equals("true") ? Boolean.TRUE : Boolean.FALSE);
        q.addConstraint("Gene.mRNAExpressionResults.expressed",  Constraints.eq(expressed));

        q.setConstraintLogic("A and B and C and D");
        q.syncLogicExpression("and");

        return q;
    }
}
