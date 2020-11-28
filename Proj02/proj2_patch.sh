#!/bin/bash


patch -f << 'EOF' 
--- bpred.c	2020-11-28 15:15:28.088902053 +0900
+++ bpred.c	2020-11-28 17:21:43.331889319 +0900
@@ -617,7 +617,7 @@
 	}
       break;
     case BPredTaken:
-      return btarget;
+      return 1;
     case BPredNotTaken:
       if ((MD_OP_FLAGS(op) & (F_CTRL|F_UNCOND)) != (F_CTRL|F_UNCOND))
 	{
@@ -625,7 +625,7 @@
 	}
       else
 	{
-	  return btarget;
+	  return 1;
 	}
     default:
       panic("bogus predictor class");
EOF
if [ $? == 0 ]; then
    echo "patch successful"
    echo "Rebuilding simulator..."
    make clean > /dev/null 2> /dev/null
    make > /dev/null 2> /dev/null 
    echo "Completed"
else
    echo "patch failed"
fi

