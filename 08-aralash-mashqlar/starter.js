// 8-mavzu: Aralash mashqlar (operatorlar + shartlar + o'zgaruvchilar + tsikllar)
// SHU FAYLDA ISHLANG. Shartlar: tasks.md faylida. Tekshirish: `node tests.js`

// 1-masala (arifmetik operatorlar)
function celsiusToFahrenheit(c) {
  return c * 9 / 5 + 32
}

// 2-masala (% va &&)
function isDivisibleBy(n, a, b) {
  return n % a == 0 && n % b == 0 ? true : false
}

// 3-masala (if / ternary)
function clamp(n, min, max) {
    return n < min ? min : n > max ? max : n
}

// 4-masala (for...of)
function countChar(text, char) {
  let count = 0;
  for(let i = 0; i < text.length; i++) {
    if(text[i] === char) count++
  }
  return count
}

// 5-masala (for...of + if)
function evenOddSums(numbers) {
   let evenSum = 0;
  let oddSum = 0;
  for(num of numbers) {
    num % 2 == 0 ? evenSum += num : oddSum += num
  }
  return {
    even: evenSum,
    odd: oddSum
  }
}

// 6-masala (if zanjiri)
function ticketPrice(age, isStudent) {
   if(age < 5) {
        return 0
    } else if(age <= 12) {
        return 5000
    } else if (age > 12 && age < 65 && isStudent) {
        return 8000 
    }
      else if (age >= 65) {
       return 6000
    } else return 12000
}

// 7-masala (formula + if zanjiri)
function bmiCategory(weightKg, heightM) {
  let bmi =  weightKg / heightM ** 2
    return bmi < 18.5 ? 'kam vazn' : 
    bmi >= 18.5 && bmi <= 24.99 ? "normal" :
    bmi >= 25 && bmi <= 29.99 ? 'ortiqcha vazn' : 'semizlik'
}

// 8-masala (for + if)
function wordCount(sentence) {
  let count = 0
    for(char of sentence) {
        if(char == ' ') count++
    }
    return count
}

// 9-masala (for + kabisa yil sharti)
function leapYearsBetween(from, to) {
   let count = 0;

    for (let year = from; year <= to; year++) {
        if (
            (year % 4 === 0 && year % 100 !== 0) ||
            year % 400 === 0
        ) {
            count++;
        }
    }

    return count;
}

// 10-masala (for + %)
function isPerfectNumber(n) {
  let result = 0;
  for(let i = 1; i < n; i++) {
    if(n % i == 0) count += i
  }
  console.log(count)
}
isPerfectNumber(6)

// 11-masala (while + % va Math.floor)
function numberToBinary(n) {
  // Shu yerga yozing
}

// 12-masala (ichma-ich tsikllar)
function primesUpTo(n) {
  // Shu yerga yozing
}

// 13-masala (ichma-ich tsikllar)
function pyramid(n) {
  // Shu yerga yozing
}

// 14-masala (tsikl + shartlar)
function studentReport(scores) {
  // Shu yerga yozing
}

// 15-masala (for...of + shartlar)
function passwordStrength(password) {
  // Shu yerga yozing
}

// 16-masala (tsikl + break/return + shartlar)
function guessGame(secret, guesses) {
  // Shu yerga yozing
}

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
