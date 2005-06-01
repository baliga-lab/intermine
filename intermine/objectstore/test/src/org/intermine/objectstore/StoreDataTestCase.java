package org.intermine.objectstore;

/*
 * Copyright (C) 2002-2005 FlyMine
 *
 * This code may be freely distributed and modified under the
 * terms of the GNU Lesser General Public Licence.  This should
 * be distributed with the code.  See the LICENSE file for more
 * information or http://www.gnu.org/copyleft/lesser.html.
 *
 */

import java.util.Date;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

import org.intermine.model.InterMineObject;
import org.intermine.objectstore.intermine.ObjectStoreWriterInterMineImpl;
import org.intermine.objectstore.query.Query;
import org.intermine.objectstore.query.QueryClass;
import org.intermine.objectstore.query.SingletonResults;

public abstract class StoreDataTestCase extends SetupDataTestCase
{
    protected static ObjectStoreWriter storeDataWriter;
    
    public StoreDataTestCase(String arg) {
        super(arg);
    }

    public static void oneTimeSetUp() throws Exception {
        SetupDataTestCase.oneTimeSetUp();
        try {
            if (storeDataWriter == null) {
                storeDataWriter = (ObjectStoreWriterInterMineImpl) ObjectStoreWriterFactory
                    .getObjectStoreWriter("osw.unittest");
            }
            storeData();
        } catch (Exception e) {
            if (storeDataWriter != null) {
                storeDataWriter.close();
            }
            throw e;
        }
    }

    public static void oneTimeTearDown() throws Exception {
        ObjectStoreQueriesTestCase.oneTimeTearDown();
        removeDataFromStore();
        storeDataWriter.close();
        storeDataWriter = null;
    }

    public static void storeData() throws Exception {
        System.out.println("Storing data");
        if (storeDataWriter == null) {
            throw new NullPointerException("storeDataWriter must be set before trying to store data");
        }
        long start = new Date().getTime();
        try {
            Iterator iter = data.entrySet().iterator();
            while (iter.hasNext()) {
                InterMineObject o = (InterMineObject) ((Map.Entry) iter.next())
                    .getValue();
                o.setId(null);
            }
            storeDataWriter.beginTransaction();
            iter = data.entrySet().iterator();
            while (iter.hasNext()) {
                Map.Entry entry = (Map.Entry) iter.next();
                InterMineObject o = (InterMineObject) entry.getValue();
                String oName = (String) entry.getKey();
                storeDataWriter.store(o);
            }
            storeDataWriter.commitTransaction();
        } catch (Exception e) {
            storeDataWriter.abortTransaction();
            throw new Exception(e);
        }

        System.out.println("Took " + (new Date().getTime() - start) + " ms to set up data");
    }

    public static void removeDataFromStore() throws Exception {
        System.out.println("Removing data");
        long start = new Date().getTime();
        if (storeDataWriter == null) {
            throw new NullPointerException("storeDataWriter must be set before trying to remove data");
        }
        try {
            storeDataWriter.beginTransaction();
            Query q = new Query();
            QueryClass qc = new QueryClass(InterMineObject.class);
            q.addFrom(qc);
            q.addToSelect(qc);
            Set dataToRemove = new SingletonResults(q, storeDataWriter.getObjectStore(),
                    storeDataWriter.getObjectStore().getSequence());
            Iterator iter = dataToRemove.iterator();
            while (iter.hasNext()) {
                InterMineObject toDelete = (InterMineObject) iter.next();
                storeDataWriter.delete(toDelete);
            }
            storeDataWriter.commitTransaction();
        } catch (RuntimeException e) {
            storeDataWriter.abortTransaction();
            storeDataWriter.beginTransaction();
            Iterator iter = data.entrySet().iterator();
            while (iter.hasNext()) {
                Map.Entry entry = (Map.Entry) iter.next();
                InterMineObject o = (InterMineObject) entry.getValue();
                String oName = (String) entry.getKey();
                storeDataWriter.delete(o);
            }
            storeDataWriter.commitTransaction();
        } catch (Exception e) {
            storeDataWriter.abortTransaction();
            throw e;
        }
        System.out.println("Took " + (new Date().getTime() - start) + " ms to remove data");
    }
}
