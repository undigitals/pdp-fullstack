// 8-mavzu: Aralash mashqlar (operatorlar + shartlar + o'zgaruvchilar + tsikllar)
// SHU FAYLDA ISHLANG. Shartlar: tasks.md faylida. Tekshirish: `node tests.js`

// 1-masala (arifmetik operatorlar)
function celsiusToFahrenheit(c) {
  return F = c * 9 / 5 + 32
}
console.log(celsiusToFahrenheit(0));



// 2-masala (% va &&)
function isDivisibleBy(n, a, b) {
  if (n % a == 0 && n % b == 0){
    return true
  } else {
    return false
  }
}
console.log(isDivisibleBy(12, 4, 6))



// 3-masala (if / ternary)
function clamp(n, min, max) {
  if (n < min) {
    return min
  } else if (n > max) {
    return max
  } else {
    return n
  }
}
console.log(clamp(12, 4, 6));



// 4-masala (for...of)
function countChar(text, char) {
  let count = 0;
    for (let i = 0; i < text.length; i++) {
        if (text[i] == char) {
            count++
        }
    }
    return count
}
console.log(countChar("hello", "l"));



// 5-masala (for...of + if)
function evenOddSums(numbers) {
  let sumEven = 0
  let sumOdd = 0
  for (const num of numbers) {
      if (num % 2 == 0) {
          sumEven += num
      } else {
          sumOdd += num
      }
  }
  return {
      sumEven: sumEven,
      sumOdd: sumOdd
  }
}
console.log(evenOddSums([1, 2, 3, 4, 5, 6]));




// 6-masala (if zanjiri)
function ticketPrice(age, isStudent) {
  if (age <= 5) {
        return 0
    } else if (age <= 12) {
        return 5000
    } else if(age >= 65) {
        return 6000
    } else if (isStudent == true) {
        return 8000
    } else {
        return 12000
    }
}
console.log(ticketPrice(4, false));
console.log(ticketPrice(10, false));
console.log(ticketPrice(70, false));
console.log(ticketPrice(20, true));
console.log(ticketPrice(20, false));




// 7-masala (formula + if zanjiri)
function bmiCategory(weightKg, heightM) {
  const bmi = weightKg / (heightM * heightM);
  
  if (bmi < 18.5) {
    return "kam vazn";
  } else if (bmi < 25) { 
    return "normal";
  } else if (bmi < 30) { 
    return "ortiqcha vazn";
  } else {
    return "semizlik";
  }
}
console.log(bmiCategory(50, 1.75)); 
console.log(bmiCategory(70, 1.75));  
console.log(bmiCategory(85, 1.75)); 
console.log(bmiCategory(100, 1.75)); 




// 8-masala (for + if)
function wordCount(sentence) {
  let count = 0;
  let inWord = false;
  for (let i = 0; i < sentence.length; i++) {
    if (sentence[i] !== ' ') {
      if (!inWord) {
        count++; 
        inWord = true; 
      }
    } else {
      inWord = false;
    }
  }
  return count;
}
console.log(wordCount("salom dunyo")); 
console.log(wordCount("  a  b   c ")); 
console.log(wordCount("   "));





// 9-masala (for + kabisa yil sharti)
function leapYearsBetween(from, to) {
  for (let i = from; i <= to; i++) {
        if (i % 100 != 0 && i % 4 == 0 || i % 400 == 0) {
            console.log(i);
        }
    }
}
console.log(leapYearsBetween(2000, 2024));




// 10-masala (for + %)
function isPerfectNumber(n) {
  let sum = 0
    for (let i = 0; i < n; i++) {
        if (n % i == 0) {
            sum += i
        }
    }
    return sum == n
}
console.log(isPerfectNumber(12));
console.log(isPerfectNumber(28));





// 11-masala (while + % va Math.floor)
function numberToBinary(n) {
  let binary = []
    while (n > 0) {
        binary.push(n % 2)
        n = Math.floor(n / 2)
    }
    return binary.reverse().join("")
}
console.log(numberToBinary(5));




// 12-masala (ichma-ich tsikllar)
function primesUpTo(n) {
  let primes = []
    for (let i = 2; i <= n; i++) {
        let isPrime = true
        for (let j = 2; j < i; j++) {
            if (i % j == 0) {
                isPrime = false
                break
            }
        }
        if (isPrime) {
            primes.push(i)
        }
    }
    return primes
}
console.log(primesUpTo(20));




// 13-masala (ichma-ich tsikllar)
function pyramid(n) {
  const result = [];
  for (let i = 1; i <= n; i++) {
    let row = "";
    for (let j = 1; j <= n - i; j++) {
      row += " ";
    }
    for (let k = 1; k <= 2 * i - 1; k++) {
      row += "*";
    }
    result.push(row);
  }
  return result;
}
console.log(pyramid(3)); 
console.log(pyramid(5)); 





// 14-masala (tsikl + shartlar)
function studentReport(scores) {
  if (scores.length === 0) {
    return { average: 0, grade: "F" };
  }

  let sum = 0;
  for (let i = 0; i < scores.length; i++) {
    sum += scores[i];
  }

  const rawAverage = sum / scores.length;
  let grade = "F";
  if (rawAverage >= 90) {
    grade = "A";
  } else if (rawAverage >= 80) {
    grade = "B";
  } else if (rawAverage >= 70) {
    grade = "C";
  } else if (rawAverage >= 60) {
    grade = "D";
  }
  const roundedAverage = Math.round(rawAverage * 10) / 10;
  return {
    average: roundedAverage,
    grade: grade
  };
}
console.log(studentReport([100, 90, 80])); 
console.log(studentReport([60, 59]));   
console.log(studentReport([85, 78, 92, 88])); 
console.log(studentReport([]));




// 15-masala (for...of + shartlar)
function passwordStrength(password) {
  let hasLength = password.length >= 8; 
  let hasDigit = false;                
  let hasUpper = false;                
  let hasSpecial = false;              
  
  for (const char of password) {
    if (char >= '0' && char <= '9') {
      hasDigit = true;
    } else if (char >= 'A' && char <= 'Z') {
      hasUpper = true;
    } else if ("!@#$%".includes(char)) {
      hasSpecial = true;
    }
  }
  let score = 0;
  if (hasLength) score++;
  if (hasDigit) score++;
  if (hasUpper) score++;
  if (hasSpecial) score++;
  
  if (score <= 1) {
    return "zaif";
  } else if (score <= 3) {
    return "o'rta";
  } else {
    return "kuchli";
  }
}
console.log(passwordStrength("abc")); 
console.log(passwordStrength("Abcdefg1")); 
console.log(passwordStrength("Abcdefg1!"));




// 16-masala (tsikl + break/return + shartlar)
function guessGame(secret, guesses) {
  let won = false;
  let attempts = 0;
  const hints = [];
  
  for (let i = 0; i < guesses.length; i++) {
    const guess = guesses[i];
    attempts++; 
    
    if (guess < secret) {
      hints.push("kattaroq");
    } else if (guess > secret) {
      hints.push("kichikroq");
    } else {
      hints.push("topdingiz");
      won = true;
      break;
    }
  }
  
  return { won, attempts, hints };
}
console.log(guessGame(5, [3, 8, 5, 9])); 
console.log(guessGame(7, [1, 2]));



module.exports = {
  celsiusToFahrenheit,
  isDivisibleBy,
  clamp,
  countChar,
  evenOddSums,
  ticketPrice,
  bmiCategory,
  wordCount,
  leapYearsBetween,
  isPerfectNumber,
  numberToBinary,
  primesUpTo,
  pyramid,
  studentReport,
  passwordStrength,
  guessGame,
};
