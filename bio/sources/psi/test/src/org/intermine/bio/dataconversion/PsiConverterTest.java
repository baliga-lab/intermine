package org.intermine.bio.dataconversion;

/*
 * Copyright (C) 2002-2008 FlyMine
 *
 * This code may be freely distributed and modified under the
 * terms of the GNU Lesser General Public Licence.  This should
 * be distributed with the code.  See the LICENSE file for more
 * information or http://www.gnu.org/copyleft/lesser.html.
 *
 */

import java.io.InputStreamReader;
import java.io.Reader;
import java.util.Collections;
import java.util.HashMap;
import java.util.Set;

import org.intermine.dataconversion.ItemsTestCase;
import org.intermine.dataconversion.MockItemWriter;
import org.intermine.metadata.Model;

public class PsiConverterTest extends ItemsTestCase
{

    Model model = Model.getInstanceByName("genomic");
    PsiConverter converter;
    MockItemWriter itemWriter;

    public PsiConverterTest(String arg) {
        super(arg);
        itemWriter = new MockItemWriter(new HashMap());
        converter = new PsiConverter(itemWriter, model);
        MockIdResolverFactory resolverFactory = new MockIdResolverFactory("Gene");
        resolverFactory.addResolverEntry("7227", "FBgn001", Collections.singleton("CG1234"));
        resolverFactory.addResolverEntry("7227", "FBgn002", Collections.singleton("CG1111"));
        converter.resolverFactory = resolverFactory;

    }

    public void setUp() throws Exception {
        super.setUp();
    }

    public void testProcess() throws Exception {

        Reader reader = new InputStreamReader(getClass().getClassLoader()
                                            .getResourceAsStream("PsiConverterTest_src.xml"));

        converter.setOrganisms("7227");
        converter.process(reader);
        converter.close();

        // uncomment to write out a new target items file
        //writeItemsFile(itemWriter.getItems(), "psi-tgt-items.xml");

        Set expected = readItemSet("PsiConverterTest_tgt.xml");

        assertEquals(expected, itemWriter.getItems());
    }
}
